// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/features/home/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    advancedStatusCheck();
  }

  advancedStatusCheck() async {
    final newVersion = NewVersionPlus(
      iOSId: 'com.svg.smart-vision-group', androidId: 'com.svg.smart_vision', androidHtmlReleaseNotes: true,
    );
    final status = await newVersion.getVersionStatus();
    if (status != null && status.canUpdate) {
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Required Update',
        dialogText: 'We’ve made Smart Vision even better! Update now to enjoy new features, smoother performance, and important improvements.',
        launchModeVersion: LaunchModeVersion.external,
        allowDismissal: false,
      );
    }else {
      await DataHelper.instance.get();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
    }
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