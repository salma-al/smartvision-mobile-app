import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import 'package:smart_vision/features/home/view/home_screen.dart';

import '../../../../core/helper/http_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loginLoading = false;

  login(context) async{
    if(emailController.text.isEmpty || passwordController.text.isEmpty) {
      ToastWidget().showToast('Please enter email and password', context);
      return;
    }
    final body = {'email': emailController.text, 'password': passwordController.text};
    try {
      loginLoading = true;
      emit(LoginLoading());
      final response = await HTTPHelper.login(EndPoints.login, body, context);
      final data = jsonDecode(response);
      if(data['message']['status'] == 'success') {
        String token = '${data['message']['token']}';
        String userId = data['message']['user_id'];
        String fullName = data['full_name'];
        String? image = data['message']['image'] == null ? null : '${HTTPHelper.imgBaseUrl}${data['message']['image']}';
        final instance = DataHelper.instance;
        instance.token = token;
        instance.userId = userId;
        instance.name = fullName;
        instance.email = emailController.text;
        instance.img = image;
        instance.set();
        await saveFcmToken(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
      }
      loginLoading = false;
      emit(LoginSuccess());
    }catch(e){
      loginLoading = false;
      emit(LoginError());
    }
  }
  saveFcmToken(context) async{
    String? token = await FirebaseMessaging.instance.getToken();
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
}