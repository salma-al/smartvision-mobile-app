import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../helper/data_helper.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
        decoration: BoxDecoration(
          color: DataHelper.instance.comp!.primaryColor,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: AppShadows.defaultShadow,
        ),
        child: Center(
          child: Text(text, style: AppTypography.p14(color: AppColors.white)),
        ),
      ),
    );
  }
}