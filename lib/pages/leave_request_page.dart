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
  int _tabIndex = 0; // 0: Request, 1: History
  String _leaveType = 'Annual Leave';
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now();
  String _duration = '0.5 hours';

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _start : _end;
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
      initialDate: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: AppColors.white,
            dialogTheme: const DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: AppShadows.popupShadow,
              borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _start = picked;
          if (_end.isBefore(_start)) _end = _start;
        } else {
          _end = picked.isBefore(_start) ? _start : picked;
        }
      });
    }
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

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

              // Start/End Dates section -- prepare for popup
              const FormLabel('Start Date'),
              const SizedBox(height: 12),
              _DateField(
                label: _formatDate(_start),
                onTap: () {/* TODO: Show popup here, not showDatePicker */},
              ),
              const SizedBox(height: AppSpacing.sameSectionMargin),
              const FormLabel('End Date'),
              const SizedBox(height: 12),
              _DateField(
                label: _formatDate(_end),
                onTap: () {/* TODO: Show popup here, not showDatePicker */},
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Reason label + styled textbox
              const FormLabel('Reason'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  boxShadow: AppShadows.popupShadow,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your reason...', border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  minLines: 2,
                  maxLines: 2,
                  style: AppTypography.body14(),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Confirm button - content-width only
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
  final VoidCallback onTap;
  const _DateField({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        onTap: onTap,
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
              const Icon(Icons.expand_more, color: AppColors.darkText, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}


