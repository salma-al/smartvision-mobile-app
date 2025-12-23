import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/filter_panel.dart';
import '../../../core/widgets/hours_badge.dart';
import '../../../core/widgets/icon_badge.dart';
import '../model/overtime_model.dart';

class OvertimeHistoryTab extends StatelessWidget {
  final List<OvertimeModel> records; 
  final Function(String, String, String) filter;
  const OvertimeHistoryTab({super.key, required this.records, required this.filter});

  @override
  Widget build(BuildContext context) {
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
          onFilter: (from, to, type, status, needAction) => filter(from, to, type),
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
        // List of history records
        ...records.map((e) => HistoryRecord(record: e)),
      ],
    );
  }
}

class HistoryRecord extends StatelessWidget {
  final OvertimeModel record;

  const HistoryRecord({super.key, required this.record});

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
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: AppColors.darkText, size: 12),
                  const SizedBox(width: 8),
                  Text(record.date, style: AppTypography.p14())
                ],
              ),
              LeaveStatusBadge(status: record.status),
            ],
          ),
          const SizedBox(height: 20),
          Text(record.reason, style: AppTypography.helperText()),
          const SizedBox(height: 8),
          // Row 2: Hours badge
          const SizedBox(height: 8),
          HoursBadge(number: record.duration),
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
              'Submitted on ${record.submitDate}',
              style: AppTypography.helperTextSmall(),
            ),
          ),
        ],
      ),
    );
  }
}