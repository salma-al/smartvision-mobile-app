import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class FormLabel extends StatelessWidget {
  final String text;
  const FormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.h4().copyWith(letterSpacing: 0.3),
    );
  }
}


