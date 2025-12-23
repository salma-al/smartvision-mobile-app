import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class TimeStateItem extends StatelessWidget {
  final String label;
  final String value;

  const TimeStateItem({
    super.key, 
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
      ),
      child: Column(
        children: [
          Text(label, style: AppTypography.helperTextSmall()),
          const SizedBox(height: 4),
          Text(value, style: AppTypography.helperTextXSmall()),
        ],
      ),
    );
  }
}