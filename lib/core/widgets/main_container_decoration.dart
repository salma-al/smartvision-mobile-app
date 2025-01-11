import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MainContainerDecoration extends StatelessWidget {
  final Widget child;
  final double? opacity, margin, padding;
  const MainContainerDecoration({super.key, required this.child, this.opacity, this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin ?? 0),
      padding: EdgeInsets.all(padding ?? 0),
      decoration: BoxDecoration(
        color: HexColor('#FFF8DB').withOpacity(opacity ?? 0.3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}