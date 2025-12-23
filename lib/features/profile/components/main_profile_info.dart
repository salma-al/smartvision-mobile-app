import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class MainProfileInfo extends StatelessWidget {
  final String label, value;
  const MainProfileInfo({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.p12(color: AppColors.lightText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.p12(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}