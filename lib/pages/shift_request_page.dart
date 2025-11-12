import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/widgets/filter_panel.dart';
import 'package:untitled1/widgets/icon_badge.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/pill_tabs.dart';
import '../widgets/form_label.dart';
import '../widgets/filter_select_field.dart';
import '../widgets/primary_button.dart';

class ShiftRequestPage extends StatefulWidget {
  const ShiftRequestPage({super.key});

  @override
  State<ShiftRequestPage> createState() => _ShiftRequestPageState();
}

class _ShiftRequestPageState extends State<ShiftRequestPage> {
  int _tabIndex = 0;
  String _shiftType = 'Work From Home';
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  String _excuseTime = '0.5 hours';
  String _excuseType = 'Late Arrival';

  OverlayEntry? _calendarOverlay;

  void _showInlineDatePicker({
    required bool isStart,
    required BuildContext fieldContext,
  }) {
    _hideInlineDatePicker(); // close existing popup if open

    final renderBox = fieldContext.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final fieldSize = renderBox.size;
    final fieldOffset = renderBox.localToGlobal(Offset.zero);

    _calendarOverlay = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final horizontalPadding = AppSpacing.pagePaddingHorizontal;
        
        // Calculate available space
        const calendarHeight = 540.0;
        final spaceBelow = screenHeight - fieldOffset.dy - fieldSize.height;
        final spaceAbove = fieldOffset.dy;
        
        // Determine if calendar should show above or below
        final showAbove = spaceBelow < calendarHeight && spaceAbove > spaceBelow;
        final topPosition = showAbove 
            ? fieldOffset.dy - calendarHeight - 8
            : fieldOffset.dy + fieldSize.height + 8;
        final maxHeight = showAbove 
            ? (spaceAbove - 16).clamp(440.0, calendarHeight)
            : (spaceBelow - 16).clamp(440.0, calendarHeight);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Close popup when tapping outside
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideInlineDatePicker,
                behavior: HitTestBehavior.opaque,
              ),
            ),
            Positioned(
              left: horizontalPadding,
              right: horizontalPadding,
              top: topPosition,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: screenWidth - horizontalPadding * 2,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                    boxShadow: AppShadows.popupShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                    child: Material(
                      color: AppColors.white,
                      child: Theme(
                        data: ThemeData(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.getAccentColor(CompanyTheme.groupCompany),
                            onPrimary: Colors.white,
                            onSurface: AppColors.darkText,
                            surface: AppColors.white,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.getAccentColor(CompanyTheme.groupCompany),
                            ),
                          ),
                          datePickerTheme: DatePickerThemeData(
                            headerHeadlineStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 0.5,
                              letterSpacing: 0,
                            ),
                            headerHelpStyle: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              height: 0.5,
                              letterSpacing: 0,
                            ),
                            dayStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 0.5,
                              letterSpacing: 0,
                            ),
                            yearStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 0.5,
                              letterSpacing: 0,
                            ),
                            headerBackgroundColor: Colors.transparent,
                            dividerColor: Colors.transparent,
                            dayOverlayColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.getAccentColor(CompanyTheme.groupCompany);
                              }
                              if (states.contains(WidgetState.hovered)) {
                                return AppColors.getAccentColor(CompanyTheme.groupCompany).withOpacity(0.1);
                              }
                              return null;
                            }),
                            dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.getAccentColor(CompanyTheme.groupCompany);
                              }
                              return null;
                            }),
                            dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return Colors.white;
                              }
                              return AppColors.darkText;
                            }),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: SizedBox(
                            width: screenWidth - horizontalPadding * 2,
                            child: CalendarDatePicker(
                              initialDate: isStart ? _start : _end,
                              firstDate: DateTime(DateTime.now().year - 1),
                              lastDate: DateTime(DateTime.now().year + 2),
                              onDateChanged: (picked) {
                                setState(() {
                                  if (isStart) {
                                    _start = picked;
                                    if (_end.isBefore(_start)) _end = _start;
                                  } else {
                                    _end = picked.isBefore(_start) ? _start : picked;
                                  }
                                });
                                _hideInlineDatePicker();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, debugRequiredFor: widget)?.insert(_calendarOverlay!);
  }

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
      appBar: const SecondaryAppBar(title: 'Shift Request'),
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
          pageSubtitle: 'View and filter your shift request history',
          typeLabel: 'Shift Type',
          typeOptions: const [
            'All',
            'Work From Home',
            'Excuse',
            'Mission',
          ],
        ),
        const SizedBox(height: AppSpacing.sectionMargin),

        // List of history records
        Column(
          children: [
            _HistoryRecord(
              shiftType: 'Work From Home',
              status: 'Approved',
              date: 'Oct 01',
              reason: 'Doctor appointment',
              submitted: 'Sep 28, 2025',
            ),
            const SizedBox(height: 12),
            _HistoryRecord(
              shiftType: 'Excuse',
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
        // Shift Type
        const FormLabel('Shift Type'),
        const SizedBox(height: AppSpacing.margin12),
        SizedBox(
          width: double.infinity,
          child: FilterSelectField(
            label: '',
            value: _shiftType,
            options: const [
              'Work From Home',
              'Excuse',
              'Mission',
            ],
            optionIcons: const {
              'Work From Home': 'assets/icons/work_from_home.svg',
              'Excuse': 'assets/icons/excuse.svg',
              'Mission': 'assets/icons/mission.svg',
            },
            onChanged: (v) => setState(() => _shiftType = v),
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
                  _DateField(
                    label: _formatDate(_start),
                    onTap: (context) =>
                        _showInlineDatePicker(isStart: true, fieldContext: context),
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
                  _DateField(
                    label: _formatDate(_end),
                    onTap: (context) =>
                        _showInlineDatePicker(isStart: false, fieldContext: context),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionMargin),

        // Excuse-specific fields
        if (_shiftType == 'Excuse') ...[
          // Excuse Time
          const FormLabel('Excuse Time'),
          const SizedBox(height: AppSpacing.margin12),
          SizedBox(
            width: double.infinity,
            child: FilterSelectField(
              label: '',
              value: _excuseTime,
              options: const [
                '0.5 hours',
                '1.0 hours',
                '1.5 hours',
                '2.0 hours',
                '2.5 hours',
                '3.0 hours',
                '3.5 hours',
                '4.0 hours',
              ],
              onChanged: (v) => setState(() => _excuseTime = v),
              popupMatchScreenWidth: true,
              screenHorizontalPadding: AppSpacing.pagePaddingHorizontal,
            ),
          ),
          const SizedBox(height: AppSpacing.sectionMargin),

          // Excuse Type
          const FormLabel('Excuse Time'),
          const SizedBox(height: AppSpacing.margin12),
          SizedBox(
            width: double.infinity,
            child: FilterSelectField(
              label: '',
              value: _excuseType,
              options: const [
                'Late Arrival',
                'Leave Early',
              ],
              onChanged: (v) => setState(() => _excuseType = v),
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
              label: 'Submit',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shift request submitted')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

// _DateField for calendar placeholder, re-usable popup migration planned
class _DateField extends StatelessWidget {
  final String label;
  final Function(BuildContext) onTap;
  const _DateField({required this.label, required this.onTap});

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
              const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.darkText),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryRecord extends StatelessWidget {
  final String shiftType;
  final String status;
  final String date;
  final String reason;
  final String submitted;

  const _HistoryRecord({
    required this.shiftType,
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
              IconBadge(name: shiftType),
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


