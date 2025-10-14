import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';

import '../../../core/utils/colors.dart';

class RequestTypeComponent extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool isSelected;
  const RequestTypeComponent({super.key, required this.onTap, required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.width * 0.27,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainColor : Colors.grey.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: isSelected ? Colors.white : AppColors.darkColor, fontSize: 16)),
      ),
    );
  }
}