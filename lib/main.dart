import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/app_constants.dart';
import 'providers/theme_provider.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/meetings_page.dart';

void main() {
  runApp(const SmartVisionApp());
}

class SmartVisionApp extends StatelessWidget {
  const SmartVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Smart Vision',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: GoogleFonts.dmSans().fontFamily,
              scaffoldBackgroundColor: AppColors.backgroundColor,
            ),
            home: const HomePage(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/home': (context) => const HomePage(),
              '/meetings': (context) => const MeetingsPage(),
            },
          );
        },
      ),
    );
  }
}