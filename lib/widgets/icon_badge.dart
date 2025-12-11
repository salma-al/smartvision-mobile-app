import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';

/// Base reusable badge (used for both icon badges and status badges)
class AppBadge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final EdgeInsets padding;
  const AppBadge({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    this.padding = const EdgeInsets.symmetric(vertical: 1.8, horizontal: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTypography.p12(color: textColor),
      ),
    );
  }
}

/// Icon + badge together (used for leave type)
class IconBadge extends StatelessWidget {
  final String name; // e.g. "Sick Leave"
  const IconBadge({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final _data = _getBadgeData(name);

    return Row(
      children: [
        Container(
          width: 32,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            'assets/icons/${_data['icon']}',
            width: 18,
            height: 18,
          ),
        ),
        const SizedBox(width: 8),
        AppBadge(
          label: name,
          bgColor: _data['bg'],
          textColor: _data['text'],
        ),
      ],
    );
  }

  /// Map badge name to icon and color scheme
  Map<String, dynamic> _getBadgeData(String name) {
    switch (name) {
      case 'Sick Leave':
        return {
          'icon': 'sick.svg',
          'bg': AppColors.lightPurple,
          'text': AppColors.purple,
        };
      case 'Casual Leave':
        return {
          'icon': 'calendar_orange.svg',
          'bg': AppColors.lightOrange,
          'text': AppColors.orange,
        };
      case 'Work From Home':
        return {
          'icon': 'work_from_home.svg',
          'bg': AppColors.lightPurple,
          'text': AppColors.purple,
        };
      case 'Excuse':
        return {
          'icon': 'excuse.svg',
          'bg': AppColors.lightOrange,
          'text': AppColors.orange,
        };
      case 'Mission':
        return {
          'icon': 'mission.svg',
          'bg': AppColors.lightBlue,
          'text': AppColors.blue,
        };
      case 'Annual Leave':
      default:
        return {
          'icon': 'palm_tree_light.svg',
          'bg': AppColors.lightBlue,
          'text': AppColors.blue,
        };
    }
  }
}

/// Status badge (uses same base badge style)
class LeaveStatusBadge extends StatelessWidget {
  final String status; // Approved, Requested, etc.
  const LeaveStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final _data = _getStatusData(status);
    return AppBadge(
      label: status,
      bgColor: _data['bg'],
      textColor: _data['text'],
    );
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status) {
      case 'Approved':
        return {'bg': AppColors.lightGreen, 'text': AppColors.green};
      case 'Requested':
        return {'bg': AppColors.lightYellow, 'text': AppColors.yellow};
      case 'Manager Approved':
        return {'bg': AppColors.lightTeal, 'text': AppColors.teal};
      case 'Cancelled':
        return {'bg': AppColors.greyStatusBG, 'text': AppColors.greyStatus};
      case 'Rejected':
      default:
        return {'bg': AppColors.lightRed, 'text': AppColors.red};
    }
  }
}
