import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/app_constants.dart';

class HoursBadge extends StatelessWidget {
  /// Either provide a number OR a text
  final num? number;
  final String? text;
  final String? helperText; // optional label like "Overtime"
  final String iconAsset;
  final String suffixText;
  final Color backgroundColor;
  final double radius;
  final EdgeInsetsGeometry padding;
  final TextStyle? helperStyle;
  final TextStyle? numberStyle;
  final TextStyle? suffixStyle;
  final TextStyle? textStyle;

  const HoursBadge({
    super.key,
    this.number,
    this.text,
    this.helperText,
    this.iconAsset = 'assets/images/clock_grey.svg',
    this.suffixText = 'Hours',
    this.backgroundColor = AppColors.lightGrey,
    this.radius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.helperStyle,
    this.numberStyle,
    this.suffixStyle,
    this.textStyle,
  }) : assert(number != null || text != null, 'Either number or text must be provided');

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
          // Show either number+suffix or arbitrary text
          if (number != null) ...[
            Text(
              number.toString(),
              style: numberStyle ?? AppTypography.helperTextSmall(),
            ),
            const SizedBox(width: 4),
            Text(
              suffixText,
              style: suffixStyle ?? AppTypography.helperTextSmall(),
            ),
          ] else if (text != null) ...[
            Text(
              text!,
              style: textStyle ?? AppTypography.helperTextSmall(),
            ),
          ],
        ],
      ),
    );
  }
}