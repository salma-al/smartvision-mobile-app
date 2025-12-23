import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class TimeLogItem extends StatelessWidget {
  final Widget icon;
  final Color iconColor;
  final String label;
  final String time;

  const TimeLogItem({
    super.key, 
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: AppTypography.helperTextSmall()),
          ),
          Text(time, style: AppTypography.helperTextSmall()),
        ],
      ),
    );
  }
}