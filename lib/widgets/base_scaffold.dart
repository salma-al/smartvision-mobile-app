import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'bottom_island.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final int currentNavIndex; // 0 = Home, 1 = Check-in, 2 = Profile

  const BaseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.currentNavIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      appBar: appBar,
      body: body,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: BottomIsland(currentIndex: currentNavIndex),
      ),
    );
  }
}


