import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class NotificationComponent extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  const NotificationComponent({
    super.key, 
    required this.type,
    required this.title,
    required this.description,
    required this.time,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.unreadBg : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.popupShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon, Badge, and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(time, style: AppTypography.helperTextSmall()),
                  if (isUnread) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.unreadDot,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: AppTypography.h4().copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: AppTypography.helperText(),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}