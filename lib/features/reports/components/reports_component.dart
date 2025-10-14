import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../core/utils/colors.dart';

class ReportsComponent extends StatelessWidget {
  final VoidCallback onTap;
  final String title, image;
  const ReportsComponent({super.key, required this.onTap, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        shadowColor: Colors.grey.withValues(alpha: 0.5),
        surfaceTintColor: HexColor('#f2f2f2'),
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: [
              Image.asset(image, fit: BoxFit.contain, width: 40, height: 40),
              const SizedBox(width: 8),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.mainColor)),
            ],
          ),
        ),
      ),
    );
  }
}