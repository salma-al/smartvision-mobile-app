import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

enum BadgeVariant { filled, outline }

class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final BadgeVariant variant;
  final EdgeInsets? padding;
  final Color? backgroundColor;

  const AppBadge({
    super.key,
    required this.label,
    required this.color,
    this.variant = BadgeVariant.filled,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOutline = variant == BadgeVariant.outline;

    // Base background
    final bgColor = isOutline
        ? Colors.transparent
        : (backgroundColor ?? color.withOpacity(0.16));

    // Border logic
    final borderSide = isOutline
        ? BorderSide(color: color, width: 1.0)
        : BorderSide(color: bgColor, width: 1.0); // ✅ stroke same as bg

    final effectivePadding =
        padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 2);

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.fromBorderSide(borderSide),
      ),
      child: Text(
        label,
        style: AppTypography.helperTextSmall(color: color),
      ),
    );
  }
}
