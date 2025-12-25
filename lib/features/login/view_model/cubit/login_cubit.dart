// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/cache_helper.dart';
import '../../../../core/helper/http_helper.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/utils/end_points.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial()) {
    getEmailAndPass();
  }

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obsecurePass = true, rememberMe = false;

  getEmailAndPass() async {
    String email = await CacheHelper.getData('email', String) ?? '';
    String password = await CacheHelper.getData('password', String) ?? '';
    emailController.text = email;
    passwordController.text = password;
    emit(SavedEmailAndPass());
  }
  toggleSave() {
    rememberMe = !rememberMe;
    emit(ToggleSave());
  }
  tooglePassword() {
    obsecurePass = !obsecurePass;
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
      emit(LoginError('Please enter email and password'));
      return;
    }
    final deviceId = await getDiveceId();
    final body = {'email': emailController.text, 'password': passwordController.text, 'device_id': deviceId};
    try {
      emit(LoginLoading());
      if(rememberMe) {
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
        instance.company = data['message']['company'];
        instance.img = data['message']['image'] == null ? null : '${HTTPHelper.fileBaseUrl}${data['message']['image']}';
        String? save = await saveFcmToken(context);
        if(save != null) {
          emit(LoginError(save));
          emit(LoginLoading());
        }
        // await checkReports(context);
        await instance.set();
        emit(LoginSuccess());
      }else {
        emit(LoginError(data['message']['message'] ?? 'Invalid email or password'));
      }
    }catch(e){
      emit(LoginError('Something went wrong, Please try again later'));
    }
  }
  Future<String?> saveFcmToken(BuildContext context) async{
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) {
      token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        return 'FCM Token still null. Check Firebase setup.';
      }
    }
    final instance = DataHelper.instance;
    final body = {'user_id': instance.userId, 'fcm_token': token};
    try {
      final data = await HTTPHelper.httpPost(EndPoints.saveToken, body, context);
      if(data['message']['status'] == 'success') {
        return 'Notification initialized';
      }
      return null;
    }catch(e){
      return 'Something went wrong';
    }
  }
  // checkReports(BuildContext context) async {
  //   final instance = DataHelper.instance;
  //   final data = await HTTPHelper.httpPost(EndPoints.availableRequests, {'employee_id': instance.userId}, context);
  //   instance.isHr = data['message']['is_hr'] ?? false;
  //   instance.isManager = data['message']['is_direct_manager'] ?? false;
  // }
}