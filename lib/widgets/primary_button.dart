import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final CompanyTheme companyTheme;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.companyTheme = CompanyTheme.groupCompany,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
        decoration: BoxDecoration(
          color: AppColors.getAccentColor(companyTheme),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: AppShadows.defaultShadow,
        ),
        child: Center(
          child: Text(label, style: AppTypography.p14(color: AppColors.white)),
        ),
      ),
    );
  }
}


