import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_vision/core/helper/shared_functions.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/hours_badge.dart';
import '../../../core/widgets/icon_badge.dart';
import 'action_button.dart';

class ApprovalRecord extends StatelessWidget {
  final String requestType;
  final String status;
  final String employeeName;
  final String? date;
  final String? dateRange;
  final String description;
  final String submitted;
  final int? hours;
  final String? hoursText;  final bool showActions;
  final bool hasAttachment;
  final String? attachmentName;
  final VoidCallback? onReject;
  final VoidCallback? onApprove;

  const ApprovalRecord({super.key, 
    required this.requestType,
    required this.status,
    required this.employeeName,
    this.date,
    this.dateRange,
    required this.description,
    required this.submitted,
    this.hours,
    this.hoursText,
    this.showActions = true,
    this.hasAttachment = false,
    this.attachmentName,
    this.onReject,
    this.onApprove,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RequestTypeBadge(name: requestType),
              LeaveStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            employeeName,
            style: AppTypography.p14(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: AppColors.darkText, size: 12),
              const SizedBox(width: 8),
              Text(
                dateRange ?? date ?? '',
                style: AppTypography.p14(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: AppTypography.helperText()),
          if (hasAttachment && attachmentName != null) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Opening $attachmentName')),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.dividerLight,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_file,
                      size: 16,
                      color: AppColors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        attachmentName!,
                        style: AppTypography.p14(color: AppColors.blue),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Hours badge (if applicable)
          if (hours != null || hoursText != null) ...[
            const SizedBox(height: 8),
            HoursBadge(
              number: hours,
              text: hoursText,
              suffixText: hours == 1 ? 'hour' : 'hours',
            )
          ],
          const SizedBox(height: 8),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Submitted on ${generateFullDate(DateTime.parse(submitted))}',
                    style: AppTypography.helperTextSmall(),
                  ),
                ),
                // Action buttons (if needed)
                if (showActions) ...[
                  const SizedBox(width: 12),
                  ActionButton(
                    label: 'Reject',
                    backgroundColor: AppColors.lightRed,
                    textColor: AppColors.red,
                    onPressed: onReject,
                    width: 85,
                  ),
                  const SizedBox(width: 8),
                  ActionButton(
                    label: 'Approve',
                    backgroundColor: AppColors.lightGreen,
                    textColor: AppColors.green,
                    onPressed: onApprove,
                    width: 85,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestTypeBadge extends StatelessWidget {
  final String name;
  const RequestTypeBadge({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final data = _getBadgeData(name);

    return Row(
      children: [
        Container(
          width: 32,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SvgPicture.asset(
            'assets/images/${data['icon']}',
            width: 18,
            height: 18,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 1.8, horizontal: 6),
          decoration: BoxDecoration(
            color: data['bg'],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            style: AppTypography.p12(color: data['text']),
          ),
        ),
      ],
    );
  }

  Map<String, dynamic> _getBadgeData(String name) {
    switch (name) {
      // Leave types
      case 'Sick Leave':
        return {
          'icon': 'sick.svg',
          'bg': AppColors.lightPurple,
          'text': AppColors.purple,
        };
      case 'Casual Leave':
        return {
          'icon': 'calendar_orange.svg',
          'bg': AppColors.lightOrange,
          'text': AppColors.orange,
        };
      case 'Annual Leave':
        return {
          'icon': 'palm_tree_light.svg',
          'bg': AppColors.lightBlue,
          'text': AppColors.blue,
        };
      // Shift types
      case 'Work From Home':
        return {
          'icon': 'work_from_home.svg',
          'bg': AppColors.lightPurple,
          'text': AppColors.purple,
        };
      case 'Excuse':
        return {
          'icon': 'excuse.svg',
          'bg': AppColors.lightOrange,
          'text': AppColors.orange,
        };
      case 'Mission':
        return {
          'icon': 'mission.svg',
          'bg': AppColors.lightBlue,
          'text': AppColors.blue,
        };
      default:
        return {
          'icon': 'palm_tree_light.svg',
          'bg': AppColors.lightBlue,
          'text': AppColors.blue,
        };
    }
  }
}