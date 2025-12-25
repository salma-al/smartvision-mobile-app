import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/inline_date_picker.dart';

class DateField extends StatelessWidget {
  final String label;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final GlobalKey _key = GlobalKey();
  final DateTime? firstDate;

  DateField({super.key, 
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _key,
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        onTap: () {
          InlineDatePicker.show(
            context: context,
            fieldKey: _key,
            initialDate: selectedDate,
            onDateSelected: onDateSelected,
            firstDate: firstDate,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
            boxShadow: AppShadows.popupShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTypography.p14()),
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.darkText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}