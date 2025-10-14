import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final Color? color, textColor;
  final double? width;
  final double? height;

  const PrimaryButton({super.key, required this.text, this.onTap, this.color, this.width, this.height, this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 52,
        width: width ?? context.width * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: color ?? HexColor('#FFF8DB').withValues(alpha: 0.65),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
