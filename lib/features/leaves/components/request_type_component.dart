import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

class RequestTypeComponent extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color background, textColor;
  const RequestTypeComponent({super.key, required this.onTap, required this.title, required this.background, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width * 0.27,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: textColor, fontSize: 16)),
      ),
    );
  }
}