import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/badge.dart';
import '../widgets/inline_date_picker.dart';
import '../widgets/filter_select_field.dart';
import '../widgets/form_label.dart';
import 'task_detail_page.dart';

class EmailAllocationsPage extends StatefulWidget {
  const EmailAllocationsPage({super.key});

  @override
  State<EmailAllocationsPage> createState() => _EmailAllocationsPageState();
}

class _EmailAllocationsPageState extends State<EmailAllocationsPage> {
  bool _showFilters = false;
  DateTime? _fromDate;
  DateTime? _toDate;
  String _selectedEmployee = 'All Employees';
  String _selectedTag = 'All Tags';
  String _selectedStatus = 'All Statuses';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _employeeOptions = [
    'All Employees',
    'Sarah Johnson',
    'Michael Chen',
    'Emma Rodriguez',
  ];

  final List<String> _tagOptions = [
    'All Tags',
    'Approval',
    'Maintenance',
    'Project Schedule',
  ];

  final List<String> _statusOptions = [
    'All Statuses',
    'Assigned',
    'In Progress',
    'In Review',
    'Completed',
    'Follow Up',
  ];

  // Mock task data
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'name': 'Sarah Johnson',
      'status': 'In Progress',
      'dateTime': 'Mon 9:00 AM',
      'title': 'Q4 Marketing Campaign Review',
      'description': 'Review Q4 marketing campaign results and prepare executive summary presentation for board meeting.',
      'tag': 'Approval',
      'assigneeEmail': 'sarah.johnson@techcorp.com',
      'assigneeInitials': 'SJ',
      'content': 'Hi team,\n\nI wanted to share the preliminary results from our Q4 marketing campaign. The engagement rates have exceeded our expectations by 25%, and we\'ve seen a significant increase in conversions across all channels.\n\nThe social media campaigns performed particularly well, with Instagram showing a 40% increase in engagement compared to Q3. Our email marketing efforts also delivered strong results with a 15% open rate improvement.\n\nI\'ve attached the detailed analytics report for your review. Let\'s schedule a meeting next week to discuss the findings and plan for Q1 2024.\n\nBest regards,\nSarah',
    },
    {
      'id': '2',
      'name': 'Michael Chen',
      'status': 'Assigned',
      'dateTime': 'Mon 8:30 AM',
      'title': 'Project Update - Mobile App Launch',
      'description': 'Address critical bugs identified in beta testing and implement UI/UX improvements for mobile app launch.',
      'tag': 'Maintenance',
      'assigneeEmail': 'mike.chen@techcorp.com',
      'assigneeInitials': 'MC',
      'content': 'Hi everyone,\n\nThe mobile app beta testing phase has been completed successfully. We received feedback from over 500 beta testers and the overall satisfaction score is 4.7/5.\n\nNext steps:\n1. Address critical bugs identified in testing\n2. Implement UI/UX improvements\n3. Prepare for production release\n\nExpected launch date: November 15th\n\nThanks for your hard work!\nMike',
    },
    {
      'id': '3',
      'name': 'Emma Rodriguez',
      'status': 'Completed',
      'dateTime': 'Sun 10/5',
      'title': 'New Design System Guidelines',
      'description': 'Update design system documentation and create component library for development team.',
      'tag': 'Maintenance',
      'assigneeEmail': 'emma.rodriguez@techcorp.com',
      'assigneeInitials': 'ER',
      'content': 'Hi team,\n\nI hope this message finds you well. I\'m excited to share our updated design system guidelines with the entire team.\n\nWe\'ve made significant improvements to:\n- Color palette and accessibility\n- Typography scales\n- Component library\n- Spacing system\n- Icon guidelines\n\nPlease review the attached documentation and feel free to reach out if you have any questions or suggestions.\n\nBest regards,\nEmma',
    },
    {
      'id': '4',
      'name': 'Sarah Johnson',
      'status': 'In Review',
      'dateTime': 'Sun 10/5',
      'title': 'Investment Proposal Meeting',
      'description': 'Prepare investment proposal presentation and financial projections for potential investors.',
      'tag': 'Approval',
      'assigneeEmail': 'sarah.johnson@techcorp.com',
      'assigneeInitials': 'SJ',
      'content': 'Hi there,\n\nThank you for taking the time to meet with us yesterday. I wanted to follow up on our discussion regarding the investment proposal.\n\nAs discussed, we\'re proposing an initial investment of \$500,000 with the following terms:\n- 15% equity stake\n- Board seat\n- Quarterly reporting\n\nPlease review the attached proposal document and let me know if you have any questions. I\'m available for a follow-up call next week.\n\nBest regards,\nDavid',
    },
    {
      'id': '5',
      'name': 'Emma Rodriguez',
      'status': 'Follow Up',
      'dateTime': 'Mon 9/8',
      'title': 'API Integration Documentation',
      'description': 'Create comprehensive API integration documentation with code examples and endpoint specifications.',
      'tag': 'Maintenance',
      'assigneeEmail': 'emma.rodriguez@techcorp.com',
      'assigneeInitials': 'ER',
      'content': 'Hi team,\n\nFollowing up on our discussion about the API integration. I\'ve prepared comprehensive documentation covering all endpoints, authentication methods, and example use cases.\n\nThe documentation includes:\n- Getting started guide\n- API reference\n- Code examples in multiple languages\n- Best practices and common pitfalls\n\nPlease review and let me know if you need any clarifications.\n\nBest,\nAlex',
    },
  ];

  // Count tasks by status
  int _getStatusCount(String status) {
    return _tasks.where((task) => task['status'] == status).length;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Assigned':
        return AppColors.yellow;
      case 'In Progress':
        return AppColors.blue;
      case 'In Review':
        return AppColors.teal;
      case 'Completed':
        return AppColors.green;
      case 'Follow Up':
        return AppColors.orange;
      default:
        return AppColors.darkText;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Assigned':
        return AppColors.lightYellow;
      case 'In Progress':
        return AppColors.lightBlue;
      case 'In Review':
        return AppColors.lightTeal;
      case 'Completed':
        return AppColors.lightGreen;
      case 'Follow Up':
        return AppColors.lightOrange;
      default:
        return AppColors.lightGrey;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildStatusCard(String status, int count) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          boxShadow: AppShadows.defaultShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBadge(
              label: status,
              color: _getStatusColor(status),
              backgroundColor: _getStatusBackgroundColor(status),
            ),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: AppTypography.h3(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: () => setState(() => _showFilters = !_showFilters),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _showFilters ? const Color(0xFFE6E3E3) : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/filter.svg',
              width: 14,
              height: 14,
              colorFilter: const ColorFilter.mode(
                AppColors.darkText,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text('Filters', style: AppTypography.p14()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    if (!_showFilters) return const SizedBox.shrink();

    final GlobalKey _fromDateKey = GlobalKey();
    final GlobalKey _toDateKey = GlobalKey();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE6E3E3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.popupShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter Options', style: AppTypography.p16()),
          const SizedBox(height: 16),

          // From Date
          const FormLabel('From Date'),
          const SizedBox(height: 8),
          GestureDetector(
            key: _fromDateKey,
            onTap: () {
              InlineDatePicker.show(
                context: context,
                fieldKey: _fromDateKey,
                initialDate: _fromDate ?? DateTime.now(),
                onDateSelected: (date) => setState(() => _fromDate = date),
                horizontalPadding: 32,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _fromDate != null
                        ? '${_fromDate!.day.toString().padLeft(2, '0')}/${_fromDate!.month.toString().padLeft(2, '0')}/${_fromDate!.year}'
                        : 'Select date',
                    style: AppTypography.p14(
                        color: _fromDate != null ? AppColors.darkText : AppColors.lightText),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.darkText),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // To Date
          const FormLabel('To Date'),
          const SizedBox(height: 8),
          GestureDetector(
            key: _toDateKey,
            onTap: () {
              InlineDatePicker.show(
                context: context,
                fieldKey: _toDateKey,
                initialDate: _toDate ?? DateTime.now(),
                onDateSelected: (date) => setState(() {
                  if (_fromDate != null && date.isBefore(_fromDate!)) {
                    _toDate = _fromDate;
                  } else {
                    _toDate = date;
                  }
                }),
                horizontalPadding: 32,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _toDate != null
                        ? '${_toDate!.day.toString().padLeft(2, '0')}/${_toDate!.month.toString().padLeft(2, '0')}/${_toDate!.year}'
                        : 'Select date',
                    style: AppTypography.p14(
                        color: _toDate != null ? AppColors.darkText : AppColors.lightText),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.darkText),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Employee
          const FormLabel('Employee'),
          const SizedBox(height: 8),
          FilterSelectField(
            label: '',
            value: _selectedEmployee,
            options: _employeeOptions,
            onChanged: (value) => setState(() => _selectedEmployee = value),
            popupMatchScreenWidth: true,
            screenHorizontalPadding: 32,
            backgroundColor: const Color(0xFFF6F6F6),
          ),

          const SizedBox(height: 16),

          // Tag
          const FormLabel('Tag'),
          const SizedBox(height: 8),
          FilterSelectField(
            label: '',
            value: _selectedTag,
            options: _tagOptions,
            onChanged: (value) => setState(() => _selectedTag = value),
            popupMatchScreenWidth: true,
            screenHorizontalPadding: 32,
            backgroundColor: const Color(0xFFF6F6F6),
          ),

          const SizedBox(height: 16),

          // Status
          const FormLabel('Status'),
          const SizedBox(height: 8),
          FilterSelectField(
            label: '',
            value: _selectedStatus,
            options: _statusOptions,
            onChanged: (value) => setState(() => _selectedStatus = value),
            popupMatchScreenWidth: true,
            screenHorizontalPadding: 32,
            backgroundColor: const Color(0xFFF6F6F6),
          ),

          const SizedBox(height: 16),

          // Search Task
          const FormLabel('Search Task'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search description or subject',
                hintStyle: AppTypography.helperText().copyWith(fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.darkText),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                filled: true,
                fillColor: const Color(0xFFF6F6F6),
              ),
              style: AppTypography.p14(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Approval':
        return AppColors.blue;
      case 'Maintenance':
        return AppColors.green;
      case 'Project Schedule':
        return AppColors.purple;
      default:
        return AppColors.darkText;
    }
  }

  Color _getTagBackgroundColor(String tag) {
    switch (tag) {
      case 'Approval':
        return AppColors.lightBlue;
      case 'Maintenance':
        return AppColors.lightGreen;
      case 'Project Schedule':
        return AppColors.lightPurple;
      default:
        return AppColors.lightGrey;
    }
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.popupShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and Status Row
          Row(
            children: [
              Expanded(
                child: Text(
                  task['name'],
                  style: AppTypography.p14().copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              AppBadge(
                label: task['status'],
                color: _getStatusColor(task['status']),
                backgroundColor: _getStatusBackgroundColor(task['status']),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Date/Time
          Text(
            task['dateTime'],
            style: AppTypography.helperTextSmall(),
          ),
          const SizedBox(height: 12),
          // Title
          Text(
            task['title'],
            style: AppTypography.h4().copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            task['description'],
            style: AppTypography.helperText(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Tag and View More Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.blue,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task['tag'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blue,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailPage(
                        task: task,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'View More',
                    style: AppTypography.p12(color: AppColors.darkText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 0,
      appBar: SecondaryAppBar(
        title: 'Email Allocations',
        notificationCount: AppColors.globalNotificationCount,
        showTitleBadge: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePaddingHorizontal,
              vertical: AppSpacing.pagePaddingVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Dashboard
                Column(
                  children: [
                    // First row - 3 columns
                    Row(
                      children: [
                        _buildStatusCard('Assigned', _getStatusCount('Assigned')),
                        const SizedBox(width: 8),
                        _buildStatusCard('In Progress', _getStatusCount('In Progress')),
                        const SizedBox(width: 8),
                        _buildStatusCard('In Review', _getStatusCount('In Review')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Second row - 2 columns
                    Row(
                      children: [
                        _buildStatusCard('Completed', _getStatusCount('Completed')),
                        const SizedBox(width: 8),
                        _buildStatusCard('Follow Up', _getStatusCount('Follow Up')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sectionMargin),

                // All Tasks Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Tasks', style: AppTypography.p16()),
                    _buildFilterButton(),
                  ],
                ),
                const SizedBox(height: 16),

                // Filter Panel
                _buildFilterPanel(),

                // Task List
                ..._tasks.map((task) => _buildTaskCard(task)).toList(),

                // Task count footer
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Text(
                    '${_tasks.length} of ${_tasks.length} tasks',
                    style: AppTypography.helperTextSmall(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

