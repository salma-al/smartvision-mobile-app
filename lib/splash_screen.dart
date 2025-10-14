// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/features/login/view/login_screen.dart';
import 'package:smart_vision/features/home/view/home_screen.dart';
import 'core/helper/http_helper.dart';
import 'core/utils/end_points.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final instance = DataHelper.instance;
    await instance.get();
    if(instance.token == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }
    final data = await HTTPHelper.httpPost(EndPoints.availableRequests, {'employee_id': instance.userId}, context);
    instance.showRequests = data['message']['has_access'] ?? false;
    instance.isHr = data['message']['is_hr'] ?? false;
    instance.isManager = data['message']['is_direct_manager'] ?? false;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen(saveToken: true)));
  }

  @override
  Widget build(BuildContext context) {
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
