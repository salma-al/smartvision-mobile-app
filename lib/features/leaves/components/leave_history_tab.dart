import 'package:flutter/material.dart';
import 'package:smart_vision/features/leaves/model/leave_model.dart';
import 'package:smart_vision/features/leaves/model/leave_types_model.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/filter_panel.dart';
import '../../../core/widgets/icon_badge.dart';

class LeaveHistoryTab extends StatelessWidget {
  final List<LeaveTypesModel> types;
  final List<LeaveModel> records;
  final Function(String, String, String) filter;
  const LeaveHistoryTab({super.key, required this.types, required this.records, required this.filter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FilterPanel with header and button
        FilterPanel(
          pageTitle: 'Request History',
          pageSubtitle: 'View and filter your leave request history',
          typeLabel: 'Leave Type',
          typeOptions: types.isEmpty ? [] : ['All', ...List<String>.from(types.map((e) => e.leaveType))],
          onFilter: (from, to, type, status, needAction) => filter(from, to, type),
        ),
        const SizedBox(height: AppSpacing.sectionMargin),
        // List of history records
        ...records.map((e) => HistoryRecord(leave: e)),
      ],
    );
  }
}

class HistoryRecord extends StatelessWidget {
  final LeaveModel leave;

  const HistoryRecord({super.key, required this.leave});

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
              IconBadge(name: leave.type),
              LeaveStatusBadge(status: leave.status),
            ],
          ),
          const SizedBox(height: 12),
          // Row 2: Date + Reason
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: AppColors.darkText, size: 12),
              const SizedBox(width: 8),
              Text(leave.fromDate, style: AppTypography.p14()),
            ],
          ),
          const SizedBox(height: 8),
          Text(leave.reason, style: AppTypography.helperText()),
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
              'Submitted on ${leave.createDate}',
              style: AppTypography.helperTextSmall(),
            ),
          ),
        ],
      ),
    );
  }
}