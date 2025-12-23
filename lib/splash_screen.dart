// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:smart_vision/core/helper/cache_helper.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
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
      _initializeApp();
    }
  }

  Future<void> _initializeApp() async {
    final instance = DataHelper.instance;
    await instance.get();
    if(instance.token == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
      return;
    }
    final data = await HTTPHelper.httpPost(EndPoints.availableRequests, {'employee_id': instance.userId}, context);
    if(data['status'] == 'fail') ToastWidget().showToast(data['message'], context);
    if(data['message']['has_log_date'] == false) {
      String email = await CacheHelper.getData('email', String) ?? '';
      String password = await CacheHelper.getData('password', String) ?? '';
      await CacheHelper.removeAllData();
      await CacheHelper.setData('email', email);
      await CacheHelper.setData('password', password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
    instance.showRequests = data['message']['has_access'] ?? false;
    instance.isHr = data['message']['is_hr'] ?? false;
    instance.isManager = data['message']['is_direct_manager'] ?? false;
    DataHelper.unreadEmailsCount = data['message']['unseen_emails_count'] ?? 0;
    DataHelper.unreadNotificationCount = data['message']['unseen_notifications_count'] ?? 0;
    DataHelper.unreadRequestsCount = data['message']['pending_requests_count'] ?? 0;
    DataHelper.isCheckedIn = data['message']['last_checkin'] != null;
    DataHelper.checkInTime = data['message']['last_checkin'] ?? '';
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
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