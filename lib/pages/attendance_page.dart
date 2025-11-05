import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/badge.dart';
import '../widgets/filter_select_field.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  String _selectedType = 'All';

  void _setMonthByName(String name) {
    final idx = _monthNames.indexOf(name);
    if (idx >= 0) {
      setState(() {
        _selectedMonth = DateTime(_selectedMonth.year, idx + 1);
      });
    }
  }

  String _formatMonth(DateTime dt) {
    return '${_monthNames[dt.month - 1]} ${dt.year}';
  }

  static const List<String> _monthNames = [
    'January','February','March','April','May','June','July','August','September','October','November','December'
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const SecondaryAppBar(title: 'Attendance Report'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.pagePaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFilters(),
              const SizedBox(height: AppSpacing.sectionMargin),
              _buildStats(),
              const SizedBox(height: AppSpacing.sectionMargin),
              _buildDailyAttendanceHeader(),
              const SizedBox(height: AppSpacing.sameSectionMargin),
              _buildDailyAttendanceList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final monthName = _monthNames[_selectedMonth.month - 1];
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, color: AppColors.darkText, size: 18),
        const SizedBox(width: 8),
        Text('Period', style: AppTypography.helperText()),
        const SizedBox(width: 12),
        Flexible(
          child: FilterSelectField(
            label: '',
            value: monthName,
            options: _monthNames,
            onChanged: _setMonthByName,
            leadingSvgAsset: null,
          ),
        ),
        const SizedBox(width: 16),
        SvgPicture.asset(
          'assets/icons/filter.svg',
          width: 18,
          height: 18,
          color: AppColors.darkText,
        ),
        const SizedBox(width: 8),
        Text('Type', style: AppTypography.helperText()),
        const SizedBox(width: 12),
        Flexible(
          child: FilterSelectField(
            label: '',
            value: _selectedType,
            options: const ['All', 'Present', 'Absent', 'Leave'],
            onChanged: (v) => setState(() => _selectedType = v),
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    Widget statItem({required Color bg, required Color color, required Widget iconWidget, required String trend, required String label}) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              const SizedBox(height: 6),
              Text(trend, style: AppTypography.h3(color: color)),
              const SizedBox(height: 4),
              Text(label, style: AppTypography.helperText()),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        statItem(bg: const Color(0xFFDCFCE7), color: AppColors.green, iconWidget: SvgPicture.asset(
          'assets/icons/arrow_up.svg',
          width: 28,
          height: 24.7,
          color: AppColors.green,
        ), trend: '12', label: 'Present'),
        const SizedBox(width: 12),
        statItem(bg: const Color(0xFFFFE2E2), color: AppColors.red, iconWidget: SvgPicture.asset(
          'assets/icons/arrow_down.svg',
          width: 28,
          height: 24.7,
          color: AppColors.red,
        ), trend: '1', label: 'Absent'),
        const SizedBox(width: 12),
        statItem(bg: const Color(0xFFDBEAFE), color: AppColors.blue, iconWidget: SvgPicture.asset(
          'assets/icons/palm_tree.svg',
          width: 26,
          height: 24.7,
          color: AppColors.blue,
        ), trend: '3', label: 'Leaves'),
      ],
    );
  }

  Widget _buildDailyAttendanceHeader() {
    return Row(
      children: [
        Text('Daily Attendance', style: AppTypography.h3()),
        const Spacer(),
        Text('9 days', style: AppTypography.helperText()),
      ],
    );
  }

  Widget _buildDailyAttendanceList() {
    final records = [
      _AttendanceRecord(day: 1, weekday: 'Mon', status: 'Present', extraBadges: [const _BadgeOutline(label: 'WFH', color: AppColors.purple)] , hours: '9h 15m', inTime: '09:15 AM', outTime: '06:30 PM'),
      _AttendanceRecord(day: 2, weekday: 'Tue', status: 'Absent', hours: '0h 0m', inTime: null, outTime: null),
      _AttendanceRecord(day: 3, weekday: 'Wed', status: 'Leave', extraBadges: [const _BadgeOutline(label: 'Excuse', color: AppColors.orange)] , hours: null, inTime: null, outTime: null),
      _AttendanceRecord(day: 4, weekday: 'Thu', status: 'Present', extraBadges: [const _BadgeOutline(label: 'Mission', color: AppColors.blue)] , hours: '8h 20m', inTime: '09:10 AM', outTime: '05:30 PM'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Column(
        children: [
          for (int i = 0; i < records.length; i++)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: i == records.length - 1
                    ? null
                    : const Border(
                        bottom: BorderSide(color: AppColors.dividerLight, width: 1.173),
                      ),
              ),
              child: _buildRecordRow(records[i]),
            ),
        ],
      ),
    );
  }

  Widget _buildRecordRow(_AttendanceRecord r) {
    Color statusColor;
    Color statusBg;
    String statusLabel;
    switch (r.status) {
      case 'Present':
        statusColor = AppColors.green;
        statusBg = AppColors.lightGreen;
        statusLabel = 'Present';
        break;
      case 'Absent':
        statusColor = AppColors.red;
        statusBg = AppColors.lightRed;
        statusLabel = 'Absent';
        break;
      default:
        statusColor = AppColors.blue;
        statusBg = AppColors.lightBlue;
        statusLabel = 'Leave';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: date tile, badges, total hours
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              width: 49.0,
              height: 49.0,
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${r.day}', style: AppTypography.p14(color: AppColors.darkText)),
                  Text(r.weekday, style: AppTypography.p12(color: AppColors.lightText)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  AppBadge(
                    label: statusLabel,
                    color: statusColor,
                    variant: BadgeVariant.filled,
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    backgroundColor: statusBg,
                  ),
                  if (r.extraBadges != null) ...[
                    for (final b in r.extraBadges!) b,
                  ],
                ],
              ),
            ),
            if (r.status != 'Leave')
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(r.hours ?? '', style: AppTypography.p14()),
                  Text('Total Hours', style: AppTypography.helperTextSmall()),
                ],
              ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: in/out or message
        if (r.status == 'Leave' || r.status == 'Absent')
          Text('No check-in recorded', style: AppTypography.helperText(), textAlign: TextAlign.left)
        else
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.helperText),
              const SizedBox(width: 6),
              Text('In:', style: AppTypography.helperText()),
              const SizedBox(width: 4),
              Text(r.inTime ?? '', style: AppTypography.helperText()),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: AppColors.helperText),
              const SizedBox(width: 6),
              Text('Out:', style: AppTypography.helperText()),
              const SizedBox(width: 4),
              Text(r.outTime ?? '', style: AppTypography.helperText()),
            ],
          ),
      ],
    );
  }
}

class _AttendanceRecord {
  final int day;
  final String weekday;
  final String status; // Present | Absent | Leave
  final String? hours;
  final String? inTime;
  final String? outTime;
  final List<_BadgeOutline>? extraBadges;
  const _AttendanceRecord({
    required this.day,
    required this.weekday,
    required this.status,
    this.hours,
    this.inTime,
    this.outTime,
    this.extraBadges,
  });
}

class _BadgeOutline extends StatelessWidget {
  final String label;
  final Color color;
  const _BadgeOutline({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return AppBadge(label: label, color: color, variant: BadgeVariant.outline);
  }
}


