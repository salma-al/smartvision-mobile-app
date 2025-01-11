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
        shadowColor: Colors.grey.withOpacity(0.5),
        surfaceTintColor: HexColor('#f2f2f2'),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, fit: BoxFit.contain, width: 70, height: 70),
              const SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: AppColors.mainColor)),
            ],
          ),
        ),
      ),
    );
  }
}