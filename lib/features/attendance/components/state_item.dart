import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class StateItem extends StatelessWidget {
  final Color bg, color;
  final String trend, label;
  final Widget iconWidget;

  const StateItem({
    super.key,
    required this.bg, 
    required this.color, 
    required this.iconWidget, 
    required this.trend, 
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 6),
            Text(trend, style: AppTypography.h3(color: color)),
            const SizedBox(height: 4),
            Text(label, style: AppTypography.helperText()),
          ],
        ),
      ),
    );
  }
}