import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../pages/check_in_page.dart'; // 👈 make sure this import path is correct

class BottomIsland extends StatelessWidget {
  const BottomIsland({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 35,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9999),
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

          // 🔘 Middle icon with navigation
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CheckInPage(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.darkText,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.login_outlined,
                color: AppColors.white,
                size: 20,
              ),
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
