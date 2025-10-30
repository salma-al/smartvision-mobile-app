import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final int notificationCount;

  const SecondaryAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.notificationCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leadingWidth: 56,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.darkText, size: 20),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : const SizedBox.shrink(),
      title: Text(title, style: AppTypography.h2()),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child:
          Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                'assets/icons/bell.svg',
                width: 16,
                height: 18.5,
                color: AppColors.darkText,
              ),
              if (notificationCount > 0)
                Positioned(
                  right: -6,
                  top: -10,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.notificationBadgeColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$notificationCount',
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
      ],
    );
  }
}


