import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_vision/features/leaves/model/leave_types_model.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/filter_select_field.dart';
import '../../../core/widgets/form_label.dart';
import '../../../core/widgets/primary_button.dart';
import 'date_field.dart';

class LeavesRequestTab extends StatelessWidget {
  final List<LeaveTypesModel> leavesTypes;
  final LeaveTypesModel? selectedLeave;
  final Function(String) changeLeaveType;
  final DateTime startDate, endDate;
  final Function(DateTime, bool) changeDate;
  final TextEditingController reasonController;
  final File? attach;
  final VoidCallback pickFile, removeFile, submit;
  const LeavesRequestTab({
    super.key, 
    required this.leavesTypes, 
    this.selectedLeave, 
    required this.changeLeaveType, 
    required this.startDate, 
    required this.endDate, 
    required this.changeDate, 
    required this.reasonController, 
    this.attach, 
    required this.pickFile, 
    required this.removeFile, 
    required this.submit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Leave Type with remaining days badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FormLabel('Leave Type'),
            AppBadge(
              label: '${selectedLeave != null ? selectedLeave!.availableLeaves : 0} Days Left',
              color: AppColors.red,
              variant: BadgeVariant.filled,
              backgroundColor: AppColors.lightRed,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.margin12),
        SizedBox(
          width: double.infinity,
          child: FilterSelectField(
            label: '',
            value: selectedLeave != null ? selectedLeave!.leaveType : '',
            options: List<String>.from(leavesTypes.map((e) => e.leaveType)),
            onChanged: (v) => changeLeaveType(v),
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
                    onDateSelected: (picked) => changeDate(picked, true),
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
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
                    onDateSelected: (picked) => changeDate(picked, false),
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
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
        // Attachment (only for Sick Leave)
        if (selectedLeave != null && selectedLeave!.leaveType.toLowerCase().contains('sick')) ...[
          const FormLabel('Attachment (Optional)'),
          const SizedBox(height: AppSpacing.margin12),
          GestureDetector(
            onTap: () => pickFile(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                boxShadow: AppShadows.popupShadow,
              ),
              child: Row(
                children: [
                  Icon(
                    attach != null ? Icons.attach_file : Icons.upload_file_outlined,
                    size: 20,
                    color: AppColors.darkText,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      attach != null ? attach!.path.split('/').last : 'Upload file...',
                      style: AppTypography.p14(color: attach != null ? AppColors.darkText : AppColors.helperText),
                    ),
                  ),
                  if (attach != null)
                    GestureDetector(
                      onTap: () => removeFile(),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sectionMargin),
        ],
        // Submit button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              text: 'Submit',
              onTap: () => submit(),
            ),
          ],
        ),
      ],
    );
  }
  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
}