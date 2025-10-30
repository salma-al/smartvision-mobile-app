import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'bottom_island.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const BaseScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.backgroundColor,
      appBar: appBar,
      body: body,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.only(bottom: 12),
        child: const BottomIsland(),
      ),
    );
  }
}


