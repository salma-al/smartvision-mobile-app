import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/pages/home_page.dart';
import '../constants/app_constants.dart';
import '../pages/check_in_page.dart'; // 👈 make sure this import path is correct
import '../pages/profile_page.dart';

class BottomIsland extends StatelessWidget {
  final int currentIndex; // 0 = Home, 1 = Check-in, 2 = Profile
  
  const BottomIsland({
    super.key,
    this.currentIndex = 0,
  });

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

          // 🔘 Home icon with navigation
          GestureDetector(
            onTap: () {
              if (currentIndex != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/icons/home.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 0
                      ? AppColors.getAccentColor(CompanyTheme.groupCompany)
                      : AppColors.darkText,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          // 🔘 Check-in icon with navigation
          GestureDetector(
            onTap: () {
              if (currentIndex != 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckInPage(),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: currentIndex == 1
                    ? AppColors.getAccentColor(CompanyTheme.groupCompany)
                    : AppColors.darkText,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/check_in.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),

          // 🔘 Profile icon with navigation
          GestureDetector(
            onTap: () {
              if (currentIndex != 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/icons/profile.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 2
                      ? AppColors.getAccentColor(CompanyTheme.groupCompany)
                      : AppColors.darkText,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
