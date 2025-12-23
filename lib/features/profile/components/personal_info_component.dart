import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class InfoColumn extends StatelessWidget {
  final String label, value;
  const InfoColumn({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.helperTextLarge(),
        ),
        const SizedBox(height: 1.5),
        Text(
          value,
          style: AppTypography.p16(),
        ),
      ],
    );
  }
}