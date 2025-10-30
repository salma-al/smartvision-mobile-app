import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/pill_tabs.dart';
import '../widgets/form_label.dart';
import '../widgets/filter_select_field.dart';
import '../widgets/primary_button.dart';

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
        final horizontalPadding = AppSpacing.pagePaddingHorizontal;

        return Stack(
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
              top: fieldOffset.dy + fieldSize.height + 8,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: screenWidth - horizontalPadding * 2,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                    boxShadow: AppShadows.popupShadow,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: AppColors.getAccentColor(CompanyTheme.groupCompany), // header & selected day color
                        onPrimary: Colors.white, // text on selected day
                        onSurface: AppColors.darkText, // default text color
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.getAccentColor(CompanyTheme.groupCompany),
                        ),
                      ),
                    ),
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
      appBar: const SecondaryAppBar(title: 'Leave Request'),
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

              // Leave Type
              const FormLabel('Leave Type'),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilterSelectField(
                  label: '',
                  value: _leaveType,
                  options: const ['Annual Leave', 'Sick Leave', 'Unpaid Leave', 'Emergency Leave'],
                  onChanged: (v) => setState(() => _leaveType = v),
                  popupMatchScreenWidth: true,
                  screenHorizontalPadding: AppSpacing.pagePaddingHorizontal,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Start & End Date in one row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormLabel('Start Date'),
                        const SizedBox(height: 12),
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
                        const SizedBox(height: 12),
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

              // Reason
              const FormLabel('Reason'),
              const SizedBox(height: 12),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryButton(
                    label: 'Confirm',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Leave request submitted')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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


