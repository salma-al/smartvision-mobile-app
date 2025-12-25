import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/home/view/home_screen.dart';
import '../../features/check_in_out/view/sign_in_out_screen.dart';
import '../../features/profile/view/profile_main_screen.dart';
import '../constants/app_constants.dart';
import '../helper/data_helper.dart';

class BottomIsland extends StatelessWidget {
  final int currentIndex; // 0 = Home, 1 = Check-in, 2 = Profile
  
  const BottomIsland({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    final primaryColor = DataHelper.instance.comp?.primaryColor ?? AppColors.svecColor;

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
          GestureDetector(
            onTap: currentIndex == 0 ? () {} : () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/images/home.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 0
                      ? primaryColor
                      : AppColors.darkText,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: currentIndex == 1 ? () {} :  () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInOutScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: currentIndex == 1
                    ? primaryColor
                    : AppColors.darkText,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/images/check_in.svg',
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: currentIndex == 2 ? () {} :  () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileMainScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/images/profile.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  currentIndex == 2
                      ? primaryColor
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