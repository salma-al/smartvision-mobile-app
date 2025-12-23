import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_constants.dart';

class InfoItem extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const InfoItem({
    super.key, 
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                icon,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTypography.helperTextSmall()),
                const SizedBox(height: 2),
                Text(value, style: AppTypography.helperTextXSmall()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}