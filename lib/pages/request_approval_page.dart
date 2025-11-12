import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled1/widgets/filter_panel.dart';
import 'package:untitled1/widgets/icon_badge.dart';
import 'package:untitled1/widgets/hours_badge.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';

class RequestApprovalPage extends StatefulWidget {
  const RequestApprovalPage({super.key});

  @override
  State<RequestApprovalPage> createState() => _RequestApprovalPageState();
}

class _RequestApprovalPageState extends State<RequestApprovalPage> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 0, // Home section
      appBar: const SecondaryAppBar(
        title: 'Request Approval',
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
              // Filter Panel includes title row with button + expandable content
              FilterPanel(
                pageTitle: 'Request Approval',
                pageSubtitle: 'View and filter your requests',
                typeLabel: 'Request Type',
                typeOptions: const [
                  'All',
                  'Overtime Requests',
                  'Leave Requests',
                  'Shift Requests',
                ],
                statusOptions: const [
                  'Request Status',
                  'Requested',
                  'Approved',
                  'Rejected',
                  'Cancelled',
                ],
                showNeedActionCheckbox: true,
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // List of approval records
              Column(
                children: [
                  _ApprovalRecord(
                    requestType: 'Sick Leave',
                    status: 'Requested',
                    employeeName: 'Salma Fouad Said',
                    date: 'Oct 01',
                    description: 'Doctor appointment',
                    submitted: 'Sep 29',
                    hasAttachment: true,
                    attachmentName: 'medical_certificate.pdf',
                    onReject: () => _handleReject('Salma Fouad Said'),
                    onApprove: () => _handleApprove('Salma Fouad Said'),
                  ),
                  const SizedBox(height: 12),
                  _ApprovalRecord(
                    requestType: 'Annual Leave',
                    status: 'Cancelled',
                    employeeName: 'Omar Hany',
                    date: 'Oct 03',
                    description: 'Annual leave',
                    submitted: 'Sep 29',
                    showActions: false,
                  ),
                  const SizedBox(height: 12),
                  _ApprovalRecord(
                    requestType: 'Excuse',
                    status: 'Manager Approved',
                    employeeName: 'Omar ELwazeery',
                    date: 'Oct 03',
                    description: 'Client meeting in Dubai',
                    submitted: 'Oct 02',
                    hours: 2,
                    onReject: () => _handleReject('Omar ELwazeery'),
                    onApprove: () => _handleApprove('Omar ELwazeery'),
                  ),
                  const SizedBox(height: 12),
                  _ApprovalRecord(
                    requestType: 'Mission',
                    status: 'Approved',
                    employeeName: 'Ahmed Radwan',
                    dateRange: 'Oct 25 - Oct 27',
                    description: 'Annual leave',
                    submitted: 'Oct 22',
                    showActions: false,
                  ),
                  const SizedBox(height: 12),
                  _ApprovalRecord(
                    requestType: 'Work From Home',
                    status: 'Rejected',
                    employeeName: 'Salma Fouad Said',
                    date: 'Oct 28',
                    description: 'WFH',
                    submitted: 'Oct 23',
                    showActions: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Footer text
              Text(
                'Showing 4 of 4 requests',
                style: AppTypography.helperTextSmall(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReject(String employeeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request from $employeeName rejected')),
    );
  }

  void _handleApprove(String employeeName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request from $employeeName approved')),
    );
  }
}

class _ApprovalRecord extends StatelessWidget {
  final String requestType;
  final String status;
  final String employeeName;
  final String? date;
  final String? dateRange;
  final String description;
  final String submitted;
  final int? hours;
  final bool showActions;
  final bool hasAttachment;
  final String? attachmentName;
  final VoidCallback? onReject;
  final VoidCallback? onApprove;

  const _ApprovalRecord({
    required this.requestType,
    required this.status,
    required this.employeeName,
    this.date,
    this.dateRange,
    required this.description,
    required this.submitted,
    this.hours,
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
              _RequestTypeBadge(name: requestType),
              LeaveStatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 12),

          // Employee name
          Text(
            employeeName,
            style: AppTypography.p14(),
          ),
          const SizedBox(height: 8),

          // Date or date range
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

          // Description
          Text(description, style: AppTypography.helperText()),

          // Attachment (if applicable)
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
                    Icon(
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
          if (hours != null) ...[
            const SizedBox(height: 8),
            HoursBadge(
              number: hours!,
              suffixText: hours == 1 ? 'hour' : 'hours',
              iconAsset: 'assets/icons/clock_grey.svg',
            ),
          ],
          const SizedBox(height: 8),

          // Submitted info with action buttons
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
                    'Submitted on $submitted',
                    style: AppTypography.helperTextSmall(),
                  ),
                ),
                // Action buttons (if needed)
                if (showActions) ...[
                  const SizedBox(width: 12),
                  _ActionButton(
                    label: 'Reject',
                    backgroundColor: AppColors.lightRed,
                    textColor: AppColors.red,
                    onPressed: onReject,
                    width: 85,
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
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

  // Helper function to get file extension
  String _getFileExtension(String filename) {
    return filename.split('.').last.toLowerCase();
  }

  // Helper function to get file icon based on extension
  IconData _getFileIcon(String filename) {
    final extension = _getFileExtension(filename);
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Helper function to get file size (mock data for now)
  String _getFileSize(String filename) {
    final extension = filename.split('.').last.toLowerCase();
    // Mock file sizes based on common file types
    switch (extension) {
      case 'pdf':
        return '1.2 MB';
      case 'doc':
      case 'docx':
        return '245 KB';
      case 'jpg':
      case 'jpeg':
      case 'png':
        return '3.5 MB';
      case 'gif':
        return '1.8 MB';
      case 'zip':
      case 'rar':
        return '5.4 MB';
      case 'xls':
      case 'xlsx':
        return '890 KB';
      default:
        return '512 KB';
    }
  }
}

class _RequestTypeBadge extends StatelessWidget {
  final String name;
  const _RequestTypeBadge({required this.name});

  @override
  Widget build(BuildContext context) {
    final _data = _getBadgeData(name);

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
            'assets/icons/${_data['icon']}',
            width: 18,
            height: 18,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 1.8, horizontal: 6),
          decoration: BoxDecoration(
            color: _data['bg'],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            style: AppTypography.p12(color: _data['text']),
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

class _ActionButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final double? width;

  const _ActionButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.p14(color: textColor),
          ),
        ),
      ),
    );
  }
}

