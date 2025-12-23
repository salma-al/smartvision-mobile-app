import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/filter_select_field.dart';
import '../../../core/widgets/form_label.dart';
import '../../../core/widgets/primary_button.dart';
import 'date_field.dart';

class ShiftRequestTab extends StatelessWidget {
  final String selectedShift, excuseTime, excuseTyoe;
  final List<String> excuseTimes;
  final Function(String) changeShift, changeExcuseTime, changeExcuseType;
  final VoidCallback submitShift;
  final DateTime startDate, endDate;
  final Function(DateTime, bool) selectDate;
  final TextEditingController reasonController;

  const ShiftRequestTab({
    super.key, 
    required this.selectedShift, 
    required this.excuseTime, 
    required this.excuseTyoe, 
    required this.excuseTimes, 
    required this.changeShift,
    required this.changeExcuseTime,
    required this.changeExcuseType,
    required this.submitShift,
    required this.startDate,
    required this.endDate,
    required this.selectDate,
    required this.reasonController
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shift Type
        const FormLabel('Shift Type'),
        const SizedBox(height: AppSpacing.margin12),
        SizedBox(
          width: double.infinity,
          child: FilterSelectField(
            label: '',
            value: selectedShift,
            options: const [
              'Work From Home',
              'Excuse',
              'Mission',
            ],
            optionIcons: const {
              'Work From Home': 'assets/images/work_from_home.svg',
              'Excuse': 'assets/images/excuse.svg',
              'Mission': 'assets/images/mission.svg',
            },
            onChanged: (v) => changeShift(v),
            popupMatchScreenWidth: true,
            screenHorizontalPadding: AppSpacing.pagePaddingHorizontal,
          ),
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
        // Start & End Dates (same row, 12px gap)
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('Start Date'),
                  const SizedBox(height: AppSpacing.margin12),
                  DateField(
                    label: _formatDate(startDate),
                    selectedDate: startDate,
                    onDateSelected: (picked) => selectDate(picked, true),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('End Date'),
                  const SizedBox(height: AppSpacing.margin12),
                  DateField(
                    label: _formatDate(endDate),
                    selectedDate: endDate,
                    onDateSelected: (picked) => selectDate(picked, false),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
        // Excuse-specific fields
        if (selectedShift.toLowerCase() == 'excuse') ...[
          // Excuse Time
          const FormLabel('Excuse Time'),
          const SizedBox(height: AppSpacing.margin12),
          SizedBox(
            width: double.infinity,
            child: FilterSelectField(
              label: '',
              value: excuseTime,
              options: excuseTimes.isNotEmpty ? excuseTimes : const [
                '0.5 hours',
                '1.0 hours',
                '1.5 hours',
                '2.0 hours',
                '2.5 hours',
                '3.0 hours',
                '3.5 hours',
                '4.0 hours',
              ],
              onChanged: (v) => changeExcuseTime(v),
              popupMatchScreenWidth: true,
              screenHorizontalPadding: AppSpacing.pagePaddingHorizontal,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionMargin),

          // Excuse Type
          const FormLabel('Excuse Type'),
          const SizedBox(height: AppSpacing.margin12),
          SizedBox(
            width: double.infinity,
            child: FilterSelectField(
              label: '',
              value: excuseTyoe,
              options: const [
                'Late Arrival',
                'Leave Early',
              ],
              onChanged: (v) => changeExcuseType(v),
              popupMatchScreenWidth: true,
              screenHorizontalPadding: AppSpacing.pagePaddingHorizontal,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionMargin),
        ],
        // Reason
        const FormLabel('Reason'),
        const SizedBox(height: AppSpacing.margin12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
            boxShadow: AppShadows.popupShadow,
          ),
          child: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              hintText: 'Type your reason...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            minLines: 2,
            maxLines: 2,
            style: AppTypography.body14(),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
        // Submit button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              text: 'Submit',
              onTap: () => submitShift(),
            ),
          ],
        ),
      ],
    );
  }
  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
}