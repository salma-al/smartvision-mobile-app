import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final double? width;

  const ActionButton({
    super.key, 
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.p14(color: textColor),
          ),
        ),
      ),
    );
  }
}