import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class BottomIsland extends StatelessWidget {
  const BottomIsland({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(
        vertical: 7, // block
        horizontal: 35, // inline
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9999), // 100% radius pill
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.apps_outlined,
            color: AppColors.getAccentColor(CompanyTheme.groupCompany),
            size: 24,
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.darkText,
              shape: BoxShape.circle, // 100% radius
            ),
            child: const Icon(
              Icons.login_outlined,
              color: AppColors.white,
              size: 20,
            ),
          ),
          Icon(
            Icons.person_outline,
            color: AppColors.darkText,
            size: 24,
          ),
        ],
      ),
    );
  }
}


