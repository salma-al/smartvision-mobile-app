import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/constants/app_constants.dart';

class HoursBadge extends StatelessWidget {
  final num number;
  final String? helperText; // optional label like "Overtime"
  final String iconAsset;
  final String suffixText;
  final Color backgroundColor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final TextStyle? helperStyle;
  final TextStyle? numberStyle;
  final TextStyle? suffixStyle;

  const HoursBadge({
    super.key,
    required this.number,
    this.helperText,
    this.iconAsset = 'assets/icons/clock_grey.svg',
    this.suffixText = 'Hours',
    this.backgroundColor = AppColors.lightGrey,
    this.radius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.helperStyle,
    this.numberStyle,
    this.suffixStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bool showHelper = helperText != null && helperText!.isNotEmpty;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 12,
            height: 12,
          ),
          if (showHelper) ...[
            const SizedBox(width: 8),
            Text(
              helperText!,
              style: helperStyle ?? AppTypography.helperText(),
            ),
            const SizedBox(width: 8),
          ],
          const SizedBox(width: 6),
          Text(
            number.toString(),
            style: numberStyle ??
                AppTypography.helperTextSmall()
          ),
          const SizedBox(width: 4),
          Text(
            suffixText,
            style: suffixStyle ?? AppTypography.helperTextSmall(),
          ),
        ],
      ),
    );
  }
}
