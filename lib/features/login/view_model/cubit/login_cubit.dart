// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/cache_helper.dart';

import '../../../../core/helper/http_helper.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/utils/end_points.dart';
import '../../../../core/widgets/toast_widget.dart';
import '../../../home/view/home_screen.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPass = false, loginLoading = false, saveEmailAndPassword = false;

  getEmailAndPass() async {
    String email = await CacheHelper.getData('email', String) ?? '';
    String password = await CacheHelper.getData('password', String) ?? '';
    emailController.text = email;
    passwordController.text = password;
    emit(SavedEmailAndPass());
  }
  toggleSave() {
    saveEmailAndPassword = !saveEmailAndPassword;
    emit(ToggleSave());
  }
  tooglePassword() {
    showPass = !showPass;
    emit(TogglePassword());
  }
  Future<String> getDiveceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown';
    }
    return 'unknown';
  }
  login(BuildContext context) async{
    if(emailController.text.isEmpty || passwordController.text.isEmpty) {
      ToastWidget().showToast('Please enter email and password', context);
      return;
    }
    final deviceId = await getDiveceId();
    final body = {'email': emailController.text, 'password': passwordController.text, 'device_id': deviceId};
    try {
      loginLoading = true;
      emit(LoginLoading());
      if(saveEmailAndPassword) {
        await CacheHelper.setData('email', emailController.text);
        await CacheHelper.setData('password', passwordController.text);
      }
      final response = await HTTPHelper.login(EndPoints.login, body, context);
      final data = jsonDecode(response);
      if(data['message']['status'] == 'success') {
        final instance = DataHelper.instance;
        instance.token = '${data['message']['token']}';
        instance.userId = data['message']['user_id'];
        instance.name = data['full_name'];
        instance.email = emailController.text;
        instance.img = data['message']['image'] == null ? null : '${HTTPHelper.imgBaseUrl}${data['message']['image']}';
        await saveFcmToken(context);
        await checkReports(context);
        await instance.set();
        loginLoading = false;
        emit(LoginSuccess());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen(saveToken: false)), (Route<dynamic> route) => false);
      }else {
        loginLoading = false;
        emit(LoginError());
        ToastWidget().showToast(data['message']['message'] ?? 'Invalid email or password', context);
      }
      emit(LoginSuccess());
    }catch(e){
      loginLoading = false;
      emit(LoginError());
      ToastWidget().showToast('Something went wrong, Please try again later', context);
    }
  }
  saveFcmToken(BuildContext context) async{
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      ToastWidget().showToast('FCM Token is null. Retrying...', context);
      await Future.delayed(const Duration(seconds: 3));
      token = await FirebaseMessaging.instance.getToken();
      
      if (token == null) {
        ToastWidget().showToast('FCM Token still null. Check Firebase setup.', context);
        return;
      }
    }
    final instance = DataHelper.instance;
    final body = {'user_id': instance.userId, 'fcm_token': token};
    try {
      final data = await HTTPHelper.httpPost(EndPoints.saveToken, body, context);
      if(data['message']['status'] == 'success') {
        ToastWidget().showToast('Notification initialized', context);
      }
    }catch(e){
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  checkReports(BuildContext context) async {
    final instance = DataHelper.instance;
    final data = await HTTPHelper.httpPost(EndPoints.availableRequests, {'employee_id': instance.userId}, context);
    instance.showRequests = data['message']['has_access'] ?? false;
    instance.isHr = data['message']['is_hr'] ?? false;
    instance.isManager = data['message']['is_direct_manager'] ?? false;
  }
}