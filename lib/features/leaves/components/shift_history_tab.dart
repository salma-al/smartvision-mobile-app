import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/filter_panel.dart';
import '../../../core/widgets/icon_badge.dart';
import '../model/shift_model.dart';

class ShiftHistoryTab extends StatelessWidget {
  final Function(String, String, String) filter;
  final List<ShiftModel> records;
  const ShiftHistoryTab({super.key, required this.filter, required this.records});

  @override
  Widget build(BuildContext context) {
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
          onFilter: (from, to, type, status, needAction) => filter(from, to, type),
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
        // List of history records
        ...records.map((e) => HistoryRecord(shift: e)),
      ],
    );
  }
}

class HistoryRecord extends StatelessWidget {
  final ShiftModel shift;
  const HistoryRecord({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
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
              IconBadge(name: shift.type),
              LeaveStatusBadge(status: shift.status),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Date + Reason
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: AppColors.darkText, size: 12),
              const SizedBox(width: 8),
              Text('${shift.from} - ${shift.to}', style: AppTypography.p14()),
            ],
          ),
          const SizedBox(height: 8),
          if(shift.reason.isNotEmpty)
          ...[
            Text(shift.reason, style: AppTypography.helperText()),
            const SizedBox(height: 8),
          ],
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
              'Submitted on ${shift.submitDate}',
              style: AppTypography.helperTextSmall(),
            ),
          ),
        ],
      ),
    );
  }
}