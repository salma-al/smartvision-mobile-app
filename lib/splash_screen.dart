// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/features/login/view/login_screen.dart';
import 'package:smart_vision/features/home/view/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async{
      final instance = DataHelper.instance;
      await instance.get();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => instance.token != null ? const HomeScreen() : const LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: HexColor('#FFF8DB'),
      body: Center(
        child: Image.asset(
          'assets/images/splash_background.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
