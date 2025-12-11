import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 0, // Home section
      appBar: SecondaryAppBar(
        title: 'Notifications',
        notificationCount: AppColors.globalNotificationCount,
        showTitleBadge: true,
        showNotificationIcon: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.pagePaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today Section
              Text('Today', style: AppTypography.p14()),
              const SizedBox(height: 12),
              _NotificationItem(
                type: 'Overtime',
                title: 'Overtime Request Approved',
                description: 'Your overtime request for November 3, 2025 has been approved by your manager.',
                time: '2 hours ago',
                isUnread: true,
              ),
              const SizedBox(height: 12),
              _NotificationItem(
                type: 'Leave',
                title: 'Leave Request Approved',
                description: 'Your leave request from November 10-12 has been approved.',
                time: '5 hours ago',
                isUnread: true,
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),

              // Yesterday Section
              Text('Yesterday', style: AppTypography.p14()),
              const SizedBox(height: 12),
              _NotificationItem(
                type: 'Announcement',
                title: 'Company Holiday Announcement',
                description: 'The office will be closed on November 15 for a company-wide team building event.',
                time: '1 day ago',
              ),
              const SizedBox(height: 12),
              _NotificationItem(
                type: 'Work From Home',
                title: 'Work From Home Approved',
                description: 'Your WFH request for November 5, 2025 has been approved.',
                time: '1 day ago',
                isUnread: true,
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),

              // This Week Section
              Text('This Week', style: AppTypography.p14()),
              const SizedBox(height: 12),
              _NotificationItem(
                type: 'Mission',
                title: 'Mission Request Approved',
                description: 'Your mission to the client site on November 8 has been approved. Travel details will follow.',
                time: '2 days ago',
              ),
              const SizedBox(height: 12),
              _NotificationItem(
                type: 'Excuse',
                title: 'Excuse Request Approved',
                description: 'Your excuse for early departure on November 2 has been approved.',
                time: '3 days ago',
              ),
              const SizedBox(height: 12),
              _NotificationItem(
                type: 'Announcement',
                title: 'New Policy Update',
                description: 'Please review the updated remote work policy in the employee handbook.',
                time: '3 days ago',
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 12),

              // Earlier Section
              Text('Earlier', style: AppTypography.p14()),
              const SizedBox(height: 12),
              _NotificationItem(
                type: 'Leave',
                title: 'Leave Request Approved',
                description: 'Your sick leave for October 30 has been approved.',
                time: '5 days ago',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  const _NotificationItem({
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
              _NotificationBadge(type: type),
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
          ),
        ],
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final String type;

  const _NotificationBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final data = _getBadgeData(type);

    return Row(
      children: [
        Container(
          width: 32,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            'assets/icons/${data['icon']}',
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              data['text'],
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 1.8, horizontal: 6),
          decoration: BoxDecoration(
            color: data['bg'],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: data['text'],
            ),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getBadgeData(String type) {
    switch (type) {
      case 'Overtime':
        return {
          'icon': 'clock_plus.svg',
          'bg': AppColors.lightYellow,
          'text': AppColors.yellow,
        };
      case 'Leave':
        return {
          'icon': 'palm_tree_light.svg',
          'bg': AppColors.lightBlue,
          'text': AppColors.blue,
        };
      case 'Announcement':
        return {
          'icon': 'speaker.svg',
          'bg': AppColors.lightGreen,
          'text': AppColors.green,
        };
      case 'Work From Home':
        return {
          'icon': 'work_from_home.svg',
          'bg': AppColors.lightPurple,
          'text': AppColors.purple,
        };
      case 'Mission':
        return {
          'icon': 'mission.svg',
          'bg': AppColors.lightBlue,
          'text': AppColors.blue,
        };
      case 'Excuse':
        return {
          'icon': 'excuse.svg',
          'bg': AppColors.lightOrange,
          'text': AppColors.orange,
        };
      default:
        return {
          'icon': 'bell.svg',
          'bg': AppColors.lightGrey,
          'text': AppColors.darkText,
        };
    }
  }
}

