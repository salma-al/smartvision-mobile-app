import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/widgets/_date_field.dart';
import 'package:untitled1/widgets/filter_panel.dart';
import 'package:untitled1/widgets/hours_badge.dart';
import 'package:untitled1/widgets/icon_badge.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/pill_tabs.dart';
import '../widgets/form_label.dart';
import '../widgets/filter_select_field.dart';
import '../widgets/primary_button.dart';

class OvertimeRequestPage extends StatefulWidget {
  const OvertimeRequestPage({super.key});

  @override
  State<OvertimeRequestPage> createState() => _OvertimeRequestPageState();
}

class _OvertimeRequestPageState extends State<OvertimeRequestPage> {
  int _tabIndex = 0;

  DateTime _overtimeDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  OverlayEntry? _calendarOverlay;

  OverlayEntry? _timeOverlay;

  void _hideInlineDatePicker() {
    _calendarOverlay?.remove();
    _calendarOverlay = null;
  }

  // ---------- Inline Time Picker ----------
  void _showInlineTimePicker({
    required BuildContext fieldContext,
    required bool isStart,
  }) {
    _hideInlineTimePicker();

    final renderBox = fieldContext.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fieldSize = renderBox.size;
    final fieldOffset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    const pickerHeight = 180.0;
    final spaceBelow = screenHeight - fieldOffset.dy - fieldSize.height;
    final spaceAbove = fieldOffset.dy;

    final showAbove =
        spaceBelow < pickerHeight && spaceAbove > spaceBelow;

    final top = showAbove
        ? fieldOffset.dy - pickerHeight - 8
        : fieldOffset.dy + fieldSize.height + 8;

    final initial = isStart ? _startTime : _endTime;

    _timeOverlay = OverlayEntry(
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

                      setState(() {
                        if (isStart) {
                          _startTime = newTime;
                        } else {
                          _endTime = newTime;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, debugRequiredFor: widget)?.insert(_timeOverlay!);
  }

  void _hideInlineTimePicker() {
    _timeOverlay?.remove();
    _timeOverlay = null;
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  void dispose() {
    _hideInlineDatePicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 0, // Home section
      appBar: const SecondaryAppBar(
        title: 'Overtime Request',
        notificationCount: AppColors.globalNotificationCount,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.pagePaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PillTabs(
                    index: _tabIndex,
                    tabs: const ['Request', 'History'],
                    onChanged: (i) => setState(() => _tabIndex = i),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionMargin),
              if (_tabIndex == 0)
                _buildRequestTab(context)
              else
                _buildHistoryTab(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overtime Date
        const FormLabel('Overtime Date'),
        const SizedBox(height: AppSpacing.margin12),
        DateField(
          label: _formatDate(_overtimeDate),
          selectedDate: _overtimeDate,
          onDateSelected: (picked) => setState(() => _overtimeDate = picked),
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
                  _DateField(
                    label: _formatTime(_startTime),
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
                  _DateField(
                    label: _formatTime(_endTime),
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
              label: 'Submit',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Overtime request submitted')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FilterPanel with header and button
        FilterPanel(
          pageTitle: 'Request History',
          pageSubtitle: 'View and filter your overtime request history',
          typeLabel: 'Status',
          typeOptions: const [
            'All',
            'Requested',
            'Manager Approved',
            'Approved',
            'Rejected'
          ],
        ),
        const SizedBox(height: AppSpacing.sectionMargin),

        // List of history records
        Column(
          children: [
            _HistoryRecord(
              status: 'Manager Approved',
              date: 'Oct 01',
              reason: 'Meeting with the team',
              submitted: 'Sep 28, 2025',
              overtimeHours: 5,
            ),
            const SizedBox(height: 12),
            _HistoryRecord(
              status: 'Requested',
              date: 'Sep 25',
              reason: 'Task completed',
              submitted: 'Sep 22, 2025',
              overtimeHours: 2.5,
            ),
            const SizedBox(height: 12),
            _HistoryRecord(
              status: 'Rejected',
              date: 'Oct 12',
              reason: 'Project 313',
              submitted: 'Oct 04, 2025',
              overtimeHours: 2.5,
            ),
          ],
        ),
      ],
    );
  }
}

// ---------- Field Widget ----------
class _DateField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function(BuildContext) onTap;

  const _DateField({
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


class _HistoryRecord extends StatelessWidget {
  final String status;
  final String date;
  final String reason;
  final String submitted;
  final num overtimeHours;

  const _HistoryRecord({
    required this.status,
    required this.date,
    required this.reason,
    required this.submitted,
    required this.overtimeHours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.popupShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Icon + badge + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, color: AppColors.darkText, size: 12),
                  const SizedBox(width: 8),
                  Text(date, style: AppTypography.p14())
                ],
              ),
              LeaveStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 12),

          const SizedBox(height: 8),
          Text(reason, style: AppTypography.helperText()),
          const SizedBox(height: 8),

          // Row 2: Hours badge
          const SizedBox(height: 8),
          HoursBadge(
            number: overtimeHours,
          ),

          const SizedBox(height: 12),

          // Row 3: Submitted info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFF3F4F6),
                  width: 1.173,
                ),
              ),
            ),
            child: Text(
              'Submitted on $submitted',
              style: AppTypography.helperTextSmall(),
            ),
          ),
        ],
      ),
    );
  }
}

