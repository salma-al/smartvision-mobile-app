import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_constants.dart';

class HomeCard extends StatelessWidget {
  final String title;
  final Color color;
  final String iconPath;
  final Widget navigateTo;
  final int? badgeCount;

  const HomeCard({
    super.key, 
    required this.title, 
    required this.color, 
    required this.iconPath, 
    required this.navigateTo,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    double itemWidth = (MediaQuery.sizeOf(context).width - 44)/2;
    return SizedBox(
      width: itemWidth,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => navigateTo)),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
            boxShadow: AppShadows.defaultShadow,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 53,
                    height: 53,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            iconPath,
                            width: 32,
                            height: 32,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF19868B),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        if (badgeCount != null && (badgeCount??0) > 0)
                          Positioned(
                            right: -5,
                            top: -5,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.notificationBadgeColor,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$badgeCount',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTypography.p12(),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}