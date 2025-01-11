import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/colors.dart';

class CheckButtons extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const CheckButtons({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}