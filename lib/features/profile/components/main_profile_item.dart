import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_constants.dart';

class MainProfileItem extends StatelessWidget {
  final String iconPath, title;
  final VoidCallback onTap;
  final bool isLogout;
  const MainProfileItem({
    super.key, 
    required this.iconPath, 
    required this.title, 
    required this.onTap, 
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          boxShadow: AppShadows.defaultShadow,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              colorFilter: isLogout 
                ? const ColorFilter.mode(
                    AppColors.red,
                    BlendMode.srcIn,
                  )
                : const ColorFilter.mode(
                    AppColors.darkText,
                    BlendMode.srcIn,
                  ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTypography.p14(
                  color: isLogout ? AppColors.red : AppColors.darkText,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isLogout ? AppColors.red : AppColors.lightText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}