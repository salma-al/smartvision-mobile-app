import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:upgrader/upgrader.dart';

import 'firebase_options.dart';
import 'notification_service.dart';
import 'splash_screen.dart';

main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await NotificationService().initialize();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Vision',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
      home: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        dialogStyle: UpgradeDialogStyle.cupertino,
        upgrader: Upgrader(
          // willDisplayUpgrade: ({required display, installedVersion, versionInfo}) {
          //   if (versionInfo != null) {
          //     if(versionInfo.appStoreVersion?.build != installedVersion) {
          //       ///show upgrade dialog
          //     }
          //   }
          // },
        ),
        child: const SplashScreen(),
      ),
    );
  }
}