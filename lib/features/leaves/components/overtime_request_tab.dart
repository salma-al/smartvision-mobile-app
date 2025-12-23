// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/form_label.dart';
import '../../../core/widgets/primary_button.dart';
import 'date_field.dart';

class OvertimeRequestTab extends StatelessWidget {
  final DateTime date;
  final Function(DateTime) changeDate;
  final TimeOfDay startTime, endTime;
  final Function(TimeOfDay, bool) changeTime;
  final Function() submit;
  final TextEditingController reasonController;
  OverlayEntry? timeOverlay;

  OvertimeRequestTab({
    super.key, 
    required this.date, 
    required this.changeDate, 
    required this.startTime, 
    required this.endTime,
    required this.changeTime,
    required this.submit,
    required this.reasonController,
    this.timeOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overtime Date
        const FormLabel('Overtime Date'),
        const SizedBox(height: AppSpacing.margin12),
        DateField(
          label: _formatDate(date),
          selectedDate: date,
          onDateSelected: (picked) => changeDate(picked),
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
        // Start / End Time (keep the existing _DateField for time)
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('Start Time'),
                  const SizedBox(height: AppSpacing.margin12),
                  TimeField(
                    label: _formatTime(startTime),
                    icon: Icons.access_time,
                    onTap: (context) => _showInlineTimePicker(
                      fieldContext: context,
                      isStart: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('End Time'),
                  const SizedBox(height: AppSpacing.margin12),
                  TimeField(
                    label: _formatTime(endTime),
                    icon: Icons.access_time,
                    onTap: (context) => _showInlineTimePicker(
                      fieldContext: context,
                      isStart: false,
                    ),
                  ),
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
              contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            minLines: 2,
            maxLines: 2,
            style: AppTypography.body14(),
          ),
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
        // Submit
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
  String _formatTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _showInlineTimePicker({required BuildContext fieldContext, required bool isStart}) {
    _hideInlineTimePicker();
    final renderBox = fieldContext.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fieldSize = renderBox.size;
    final fieldOffset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(fieldContext).size.height;

    const pickerHeight = 180.0;
    final spaceBelow = screenHeight - fieldOffset.dy - fieldSize.height;
    final spaceAbove = fieldOffset.dy;

    final showAbove = spaceBelow < pickerHeight && spaceAbove > spaceBelow;

    final top = showAbove ? fieldOffset.dy - pickerHeight - 8 : fieldOffset.dy + fieldSize.height + 8;

    final initial = isStart ? startTime : endTime;

    timeOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Close when tapping outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideInlineTimePicker,
                behavior: HitTestBehavior.opaque,
              ),
            ),

            Positioned(
              left: AppSpacing.pagePaddingHorizontal,
              right: AppSpacing.pagePaddingHorizontal,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  height: pickerHeight,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: AppShadows.popupShadow,
                  ),
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: Duration(
                      hours: initial.hour,
                      minutes: initial.minute,
                    ),
                    onTimerDurationChanged: (duration) {
                      final newTime = TimeOfDay(
                        hour: duration.inHours,
                        minute: duration.inMinutes % 60,
                      );
                      changeTime(newTime, isStart);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(fieldContext, debugRequiredFor: this).insert(timeOverlay!);
  }

  void _hideInlineTimePicker() {
    timeOverlay?.remove();
    timeOverlay = null;
  }
}

class TimeField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function(BuildContext) onTap;

  const TimeField({
    super.key, 
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        onTap: () => onTap(context),
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
              Icon(icon, size: 16, color: AppColors.darkText),
            ],
          ),
        ),
      ),
    );
  }
}