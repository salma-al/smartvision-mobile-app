import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/widgets/_date_field.dart';
import 'package:untitled1/widgets/filter_panel.dart';
import 'package:untitled1/widgets/icon_badge.dart';
import 'package:untitled1/widgets/inline_date_picker.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/pill_tabs.dart';
import '../widgets/form_label.dart';
import '../widgets/filter_select_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/badge.dart' as badge;

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  int _tabIndex = 0;
  String _leaveType = 'Annual Leave';
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  String? _attachmentFileName;

  // Map of leave types to remaining days
  final Map<String, int> _leaveDaysRemaining = {
    'Annual Leave': 12,
    'Sick Leave': 5,
    'Unpaid Leave': 0,
    'Emergency Leave': 3,
  };

  OverlayEntry? _calendarOverlay;

  void _hideInlineDatePicker() {
    _calendarOverlay?.remove();
    _calendarOverlay = null;
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

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
        title: 'Leave Request',
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

  Widget _buildHistoryTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FilterPanel with header and button
        FilterPanel(
          pageTitle: 'Request History',
          pageSubtitle: 'View and filter your leave request history',
          typeLabel: 'Leave Type',
          typeOptions: const [
            'All',
            'Casual Leave',
            'Sick Leave',
            'Annual Leave',
            'Leave without pay'
          ],
        ),
        const SizedBox(height: AppSpacing.sectionMargin),

        // List of history records
        Column(
          children: [
            _HistoryRecord(
              leaveType: 'Sick Leave',
              status: 'Approved',
              date: 'Oct 01',
              reason: 'Doctor appointment',
              submitted: 'Sep 28, 2025',
            ),
            const SizedBox(height: 12),
            _HistoryRecord(
              leaveType: 'Casual Leave',
              status: 'Requested',
              date: 'Sep 25',
              reason: 'Family event',
              submitted: 'Sep 22, 2025',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequestTab(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Leave Type with remaining days badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FormLabel('Leave Type'),
            badge.AppBadge(
              label: '${_leaveDaysRemaining[_leaveType] ?? 0} Days Left',
              color: AppColors.red,
              variant: badge.BadgeVariant.filled,
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
            value: _leaveType,
            options: const [
              'Annual Leave',
              'Sick Leave',
              'Unpaid Leave',
              'Emergency Leave',
            ],
            onChanged: (v) => setState(() => _leaveType = v),
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
                    label: _formatDate(_start),
                    selectedDate: _start,
                    onDateSelected: (picked) {
                      setState(() {
                        _start = picked;
                        if (_end.isBefore(_start)) _end = _start;
                      });
                    },
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
                    label: _formatDate(_end),
                    selectedDate: _end,
                    onDateSelected: (picked) {
                      setState(() {
                        _end = picked.isBefore(_start) ? _start : picked;
                      });
                    },
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
        if (_leaveType == 'Sick Leave') ...[
          const FormLabel('Attachment (Optional)'),
          const SizedBox(height: AppSpacing.margin12),
          GestureDetector(
            onTap: () {
              // Simulate file picking
              setState(() {
                _attachmentFileName = 'medical_certificate.pdf';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('File attached successfully')),
              );
            },
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
                    _attachmentFileName != null
                        ? Icons.attach_file
                        : Icons.upload_file_outlined,
                    size: 20,
                    color: AppColors.darkText,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _attachmentFileName ?? 'Upload file...',
                      style: AppTypography.p14(
                        color: _attachmentFileName != null
                            ? AppColors.darkText
                            : AppColors.helperText,
                      ),
                    ),
                  ),
                  if (_attachmentFileName != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _attachmentFileName = null;
                        });
                      },
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
              label: 'Submit',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Leave request submitted')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _HistoryRecord extends StatelessWidget {
  final String leaveType;
  final String status;
  final String date;
  final String reason;
  final String submitted;

  const _HistoryRecord({
    required this.leaveType,
    required this.status,
    required this.date,
    required this.reason,
    required this.submitted,
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
              IconBadge(name: leaveType),
              LeaveStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Date + Reason
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: AppColors.darkText, size: 12),
              const SizedBox(width: 8),
              Text(date, style: AppTypography.p14()),
            ],
          ),
          const SizedBox(height: 8),
          Text(reason, style: AppTypography.helperText()),
          const SizedBox(height: 8),

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


