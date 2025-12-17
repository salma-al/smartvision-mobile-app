import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import 'email_detail_page.dart';
 
class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  // Filter state
  String _dateFilter = 'All Time';
  String _statusFilter = 'All';
  String _emailAccountFilter = 'All';
  bool _isReceived = true;
  bool _isOpened = false;
  bool _isAllocated = false;
  bool _assignedToMe = false;
  List<String> _selectedTags = [];
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  
  final FocusNode _fromFocusNode = FocusNode();
  final FocusNode _toFocusNode = FocusNode();
  final FocusNode _subjectFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  final List<String> _availableTags = [
    'Approval',
    'Down Payment',
    'Final Payment',
    'Project Schedule',
  ];

  final List<String> _emailAccounts = [
    'All',
    'work@company.com',
    'sales@company.com',
    'support@company.com',
    'hr@company.com',
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _subjectController.dispose();
    _contentController.dispose();
    _fromFocusNode.dispose();
    _toFocusNode.dispose();
    _subjectFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _showFilterDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterDrawer(),
    );
  }

  Widget _buildFilterDrawer() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    bottom: BorderSide(color: AppColors.dividerLight, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Filters', style: AppTypography.h3()),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _clearFilters();
                            });
                            setState(() {});
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Clear All',
                            style: AppTypography.p14(color: AppColors.red),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.darkText, size: 20),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Filter Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                    onTap: () {
                      // Unfocus all text fields when tapping outside
                      FocusScope.of(context).unfocus();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      // Search Section
                      Text('Search', style: AppTypography.p16()),
                      const SizedBox(height: 12),
                      _buildTextField('Subject', _subjectController, _subjectFocusNode, setModalState),
                      const SizedBox(height: 10),
                      _buildTextField('Content', _contentController, _contentFocusNode, setModalState),
                      const SizedBox(height: 10),
                      _buildTextField('From', _fromController, _fromFocusNode, setModalState),
                      const SizedBox(height: 10),
                      _buildTextField('To', _toController, _toFocusNode, setModalState),
                      const SizedBox(height: 20),

                      // Status & Date Section
                      Text('Status & Date', style: AppTypography.p16()),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        'Status',
                        _statusFilter,
                        ['All', 'Open', 'Replied', 'Closed', 'Spam'],
                        (value) {
                          setModalState(() => _statusFilter = value ?? 'All');
                          setState(() => _statusFilter = value ?? 'All');
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDropdown(
                        'Date',
                        _dateFilter,
                        ['All Time', 'Today', 'Last 7 Days', 'Last 30 Days', 'Last 3 Months'],
                        (value) {
                          setModalState(() => _dateFilter = value ?? 'All Time');
                          setState(() => _dateFilter = value ?? 'All Time');
                        },
                      ),
                      const SizedBox(height: 20),

                      // Email Account
                      Text('Email Account', style: AppTypography.p16()),
                      const SizedBox(height: 12),
                      _buildDropdown(
                        'Account',
                        _emailAccountFilter,
                        _emailAccounts,
                        (value) {
                          setModalState(() => _emailAccountFilter = value ?? 'All');
                          setState(() => _emailAccountFilter = value ?? 'All');
                        },
                      ),
                      const SizedBox(height: 20),

                      // Tags Section
                      Text('Tags', style: AppTypography.p16()),
                      const SizedBox(height: 12),
                      Theme(
                        data: Theme.of(context).copyWith(
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableTags.map((tag) {
                            final isSelected = _selectedTags.contains(tag);
                            return FilterChip(
                              label: Text(tag),
                              selected: isSelected,
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    _selectedTags.add(tag);
                                  } else {
                                    _selectedTags.remove(tag);
                                  }
                                });
                                setState(() {});
                              },
                              backgroundColor: AppColors.white,
                              selectedColor: AppColors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? AppColors.getAccentColor(CompanyTheme.groupCompany) : AppColors.darkText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              side: BorderSide(
                                color: isSelected ? AppColors.getAccentColor(CompanyTheme.groupCompany) : AppColors.dividerLight,
                                width: isSelected ? 1.5 : 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              showCheckmark: false,
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick Filters
                      Text('Quick Filters', style: AppTypography.p16()),
                      const SizedBox(height: 12),
                      _buildToggleRow(
                        'Received',
                        'Sent',
                        _isReceived,
                        (isLeft) {
                          setModalState(() => _isReceived = isLeft);
                          setState(() => _isReceived = isLeft);
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildToggleRow(
                        'Unread',
                        'Read',
                        !_isOpened,
                        (isLeft) {
                          setModalState(() => _isOpened = !isLeft);
                          setState(() => _isOpened = !isLeft);
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildToggleRow(
                        'Not Allocated',
                        'Allocated',
                        !_isAllocated,
                        (isLeft) {
                          setModalState(() => _isAllocated = !isLeft);
                          setState(() => _isAllocated = !isLeft);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildCheckbox(
                        'Assigned to me only',
                        _assignedToMe,
                        (value) {
                          setModalState(() => _assignedToMe = value ?? false);
                          setState(() => _assignedToMe = value ?? false);
                        },
                      ),
                      const SizedBox(height: 70), // Space for apply button
                      ],
                    ),
                  ),
                ),
              ),

              // Apply Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    top: BorderSide(color: AppColors.dividerLight, width: 1),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Apply filters
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.getAccentColor(CompanyTheme.groupCompany),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply Filters',
                      style: AppTypography.p14(color: AppColors.white).copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, FocusNode focusNode, StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.helperText().copyWith(fontSize: 13)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: AppShadows.defaultShadow,
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              setModalState(() {});
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: AppTypography.helperText().copyWith(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.getAccentColor(CompanyTheme.groupCompany),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              filled: true,
              fillColor: AppColors.white,
            ),
            style: AppTypography.p14(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: AppTypography.helperText().copyWith(fontSize: 13)),
          const SizedBox(height: 6),
        ],
        PopupMenuButton<String>(
          onSelected: onChanged,
          offset: const Offset(0, 50),
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) {
            return options.map((option) {
              final isSelected = option == value;
              return PopupMenuItem<String>(
                value: option,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: AppTypography.p14(
                          color: isSelected ? AppColors.getAccentColor(CompanyTheme.groupCompany) : AppColors.darkText,
                        ).copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check,
                        size: 18,
                        color: AppColors.getAccentColor(CompanyTheme.groupCompany),
                      ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppShadows.defaultShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: AppTypography.p14()),
                Icon(Icons.expand_more, size: 20, color: AppColors.darkText),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleRow(String leftLabel, String rightLabel, bool isLeft, Function(bool) onToggle) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isLeft ? const Color(0xFFEFF6FF) : AppColors.white,
                border: Border.all(
                  color: isLeft ? AppColors.unreadDot : AppColors.dividerLight,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: Text(
                leftLabel,
                textAlign: TextAlign.center,
                style: AppTypography.p14(
                  color: isLeft ? AppColors.unreadDot : AppColors.darkText,
                ).copyWith(fontWeight: isLeft ? FontWeight.w600 : FontWeight.w400, fontSize: 13),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: !isLeft ? const Color(0xFFEFF6FF) : AppColors.white,
                border: Border.all(
                  color: !isLeft ? AppColors.unreadDot : AppColors.dividerLight,
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Text(
                rightLabel,
                textAlign: TextAlign.center,
                style: AppTypography.p14(
                  color: !isLeft ? AppColors.unreadDot : AppColors.darkText,
                ).copyWith(fontWeight: !isLeft ? FontWeight.w600 : FontWeight.w400, fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.darkText,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(label, style: AppTypography.p14()),
          ),
        ),
      ],
    );
  }

  void _clearFilters() {
    _dateFilter = 'All Time';
    _statusFilter = 'All';
    _emailAccountFilter = 'All';
    _isReceived = true;
    _isOpened = false;
    _isAllocated = false;
    _assignedToMe = false;
    _selectedTags.clear();
    _fromController.clear();
    _toController.clear();
    _subjectController.clear();
    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 0,
      appBar: SecondaryAppBar(
        title: 'Inbox',
        notificationCount: AppColors.globalNotificationCount,
        showTitleBadge: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePaddingHorizontal,
                  // vertical: 16,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  border: Border(
                    bottom: BorderSide(color: AppColors.dividerLight, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Inbox Filters', style: AppTypography.p16()),
                        // const SizedBox(height: 4),
                        Text(
                          'View and filter your emails',
                          style: AppTypography.helperTextSmall(),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _showFilterDrawer,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.dividerLight),
                        ),
                        child: Row(
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
                    ),
                  ],
                ),
              ),
              
              // Email List Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePaddingHorizontal,
                  vertical: AppSpacing.pagePaddingVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

              // Today Section
              Text('Today', style: AppTypography.p14()),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailDetailPage(
                              sender: 'Sarah Johnson',
                              senderEmail: 'sarah.johnson@techcorp.com',
                              senderInitials: 'SJ',
                              subject: 'Q4 Marketing Campaign Review',
                              content: 'Hi team,\n\nI wanted to share the preliminary results from our Q4 marketing campaign. The engagement rates have exceeded our expectations by 25%, and we\'ve seen a significant increase in conversions across all channels.\n\nThe social media campaigns performed particularly well, with Instagram showing a 40% increase in engagement compared to Q3. Our email marketing efforts also delivered strong results with a 15% open rate improvement.\n\nI\'ve attached the detailed analytics report for your review. Let\'s schedule a meeting next week to discuss the findings and plan for Q1 2024.\n\nBest regards,\nSarah',
                              time: 'Mon 9:00 AM',
                              tags: ['Approval'],
                              hasAttachment: true,
                              attachments: [
                                {'name': 'Q4_Marketing_Report.pdf', 'type': 'PDF Document'},
                                {'name': 'Analytics_Data.xlsx', 'type': 'Excel Spreadsheet'},
                              ],
                      ),
                    ),
                  );
                },
                child: const _EmailItem(
                  sender: 'Sarah Johnson',
                        senderInitials: 'SJ',
                        subject: 'Q4 Marketing Campaign Review',
                        preview: 'Hi team, I wanted to share the preliminary results from our Q4 marketing campaign. The engagement...',
                        time: 'Mon 9:00 AM',
                        isUnread: true,
                        hasAttachment: true,
                        tags: ['Approval'],
                      ),
                    ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailDetailPage(
                              sender: 'Michael Chen',
                              senderEmail: 'mike.chen@techcorp.com',
                              senderInitials: 'MC',
                              subject: 'Project Update – Mobile App Launch',
                              content: 'Hi everyone,\n\nThe mobile app beta testing phase has been completed successfully. We received feedback from over 500 beta testers and the overall satisfaction score is 4.7/5.\n\nNext steps:\n1. Address critical bugs identified in testing\n2. Implement UI/UX improvements\n3. Prepare for production release\n\nExpected launch date: November 15th\n\nThanks for your hard work!\nMike',
                              time: 'Mon 8:30 AM',
                              tags: ['Project Schedule'],
                              hasAttachment: false,
                      ),
                    ),
                  );
                },
                child: const _EmailItem(
                  sender: 'Michael Chen',
                        senderInitials: 'MC',
                        subject: 'Project Update – Mobile App Launch',
                        preview: 'Hi everyone, The mobile app beta testing phase has been completed successfully. We received feedback...',
                        time: 'Mon 8:30 AM',
                        isUnread: true,
                        tags: ['Project Schedule'],
                      ),
                    ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailDetailPage(
                              sender: 'Alex Kumar',
                              senderEmail: 'alex.kumar@techcorp.com',
                              senderInitials: 'AK',
                              subject: 'API Integration Documentation',
                              content: 'Hi team,\n\nFollowing up on our discussion about the API integration. I\'ve prepared comprehensive documentation covering all endpoints, authentication methods, and example use cases.\n\nThe documentation includes:\n- Getting started guide\n- API reference\n- Code examples in multiple languages\n- Best practices and common pitfalls\n\nPlease review and let me know if you need any clarifications.\n\nBest,\nAlex',
                              time: 'Mon 9/8',
                              tags: [],
                              hasAttachment: false,
                      ),
                    ),
                  );
                },
                child: const _EmailItem(
                  sender: 'Alex Kumar',
                        senderInitials: 'AK',
                        subject: 'API Integration Documentation',
                        preview: 'Following up on our discussion about the API integration. I\'ve prepared comprehensive...',
                        time: 'Mon 9/8',
                        isUnread: false,
                        tags: [],
                      ),
                    ),
              const SizedBox(height: 24),

              // Yesterday Section
              Text('Yesterday', style: AppTypography.p14()),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailDetailPage(
                              sender: 'Emma Rodriguez',
                              senderEmail: 'emma.rodriguez@techcorp.com',
                              senderInitials: 'ER',
                              subject: 'New Design System Guidelines',
                              content: 'Hi team,\n\nI hope this message finds you well. I\'m excited to share our updated design system guidelines with the entire team.\n\nWe\'ve made significant improvements to:\n- Color palette and accessibility\n- Typography scales\n- Component library\n- Spacing system\n- Icon guidelines\n\nPlease review the attached documentation and feel free to reach out if you have any questions or suggestions.\n\nBest regards,\nEmma',
                              time: 'Sun 10/5',
                              tags: [],
                              hasAttachment: true,
                              attachments: [
                                {'name': 'Design_System_v2.pdf', 'type': 'PDF Document'},
                              ],
                      ),
                    ),
                  );
                },
                child: const _EmailItem(
                  sender: 'Emma Rodriguez',
                        senderInitials: 'ER',
                        subject: 'New Design System Guidelines',
                        preview: 'I hope this message finds you well. I\'m excited to share our updated design system guidelines with the...',
                        time: 'Sun 10/5',
                        isUnread: true,
                        hasAttachment: true,
                        tags: [],
                      ),
                    ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailDetailPage(
                              sender: 'David Park',
                              senderEmail: 'david.park@investments.com',
                              senderInitials: 'DP',
                              subject: 'Investment Proposal Meeting',
                              content: 'Hi there,\n\nThank you for taking the time to meet with us yesterday. I wanted to follow up on our discussion regarding the investment proposal.\n\nAs discussed, we\'re proposing an initial investment of \$500,000 with the following terms:\n- 15% equity stake\n- Board seat\n- Quarterly reporting\n\nPlease review the attached proposal document and let me know if you have any questions. I\'m available for a follow-up call next week.\n\nBest regards,\nDavid',
                              time: 'Sun 10/5',
                              tags: ['Down Payment'],
                              hasAttachment: false,
                      ),
                    ),
                  );
                },
                child: const _EmailItem(
                  sender: 'David Park',
                        senderInitials: 'DP',
                        subject: 'Investment Proposal Meeting',
                        preview: 'Thank you for taking the time to meet with us yesterday. I wanted to follow up on our discussion...',
                        time: 'Sun 10/5',
                        isUnread: false,
                        tags: ['Down Payment'],
                      ),
                    ),
              const SizedBox(height: 24),

              // Last Week Section
              Text('Last Week', style: AppTypography.p14()),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailDetailPage(
                              sender: 'Lisa Thompson',
                              senderEmail: 'lisa.thompson@techcorp.com',
                              senderInitials: 'LT',
                              subject: 'Client Feedback Summary',
                              content: 'Hi team,\n\nI wanted to provide you with a comprehensive summary of the client feedback we received this quarter.\n\nOverall satisfaction: 4.5/5\nKey highlights:\n- 95% would recommend our services\n- Response time improved by 30%\n- Product quality consistently rated excellent\n\nAreas for improvement:\n- Documentation clarity\n- Onboarding process\n- Support hours expansion\n\nI\'ve attached the detailed report with all client comments and recommendations.\n\nBest,\nLisa',
                              time: 'Tue 9/9',
                              tags: ['Final Payment'],
                              hasAttachment: true,
                              attachments: [
                                {'name': 'Client_Feedback_Q4.pdf', 'type': 'PDF Document'},
                              ],
                      ),
                    ),
                  );
                },
                child: const _EmailItem(
                  sender: 'Lisa Thompson',
                        senderInitials: 'LT',
                        subject: 'Client Feedback Summary',
                        preview: 'I wanted to provide you with a comprehensive summary of the client feedback we received this...',
                        time: 'Tue 9/9',
                        isUnread: false,
                        hasAttachment: true,
                        tags: ['Final Payment'],
                      ),
                    ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailDetailPage(
                              sender: 'John Martinez',
                              senderEmail: 'john.martinez@techcorp.com',
                              senderInitials: 'JM',
                              subject: 'Budget Review Q4 2025',
                              content: 'Hi team,\n\nPlease find attached the budget review for Q4 2025. We need to discuss some adjustments based on the recent market changes and revenue projections.\n\nKey points:\n- Marketing budget increase of 15%\n- R&D investment adjustment\n- Operational cost optimization\n- New hire budget review\n\nLet\'s schedule a meeting to go through these changes in detail. I\'m available Tuesday or Thursday afternoon.\n\nBest regards,\nJohn',
                              time: 'Mon 9/8',
                              tags: ['Approval'],
                              hasAttachment: true,
                              attachments: [
                                {'name': 'Budget_Review_Q4_2025.xlsx', 'type': 'Excel Spreadsheet'},
                              ],
                      ),
                    ),
                  );
                },
                child: const _EmailItem(
                  sender: 'John Martinez',
                        senderInitials: 'JM',
                        subject: 'Budget Review Q4 2025',
                        preview: 'Please find attached the budget review for Q4 2025. We need to discuss some adjustments...',
                        time: 'Mon 9/8',
                        isUnread: false,
                        hasAttachment: true,
                        tags: ['Approval'],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailItem extends StatelessWidget {
  final String sender;
  final String senderInitials;
  final String subject;
  final String preview;
  final String time;
  final bool isUnread;
  final bool hasAttachment;
  final List<String> tags;

  const _EmailItem({
    required this.sender,
    required this.senderInitials,
    required this.subject,
    required this.preview,
    required this.time,
    this.isUnread = false,
    this.hasAttachment = false,
    required this.tags,
  });

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Approval':
        return AppColors.blue;
      case 'Down Payment':
        return AppColors.orange;
      case 'Final Payment':
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
      case 'Down Payment':
        return AppColors.lightOrange;
      case 'Final Payment':
        return AppColors.lightGreen;
      case 'Project Schedule':
        return AppColors.lightPurple;
      default:
        return AppColors.lightGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.unreadBg : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.popupShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender and Time Row
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.svecColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    senderInitials,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          sender,
                          style: AppTypography.p14(
                            color: AppColors.darkText,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (hasAttachment) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.attach_file,
                            size: 14,
                            color: AppColors.helperText,
                          ),
                        ],
                      ],
                    ),
                    if (tags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getTagBackgroundColor(tag),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: _getTagColor(tag),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                children: [
                  Text(time, style: AppTypography.helperTextSmall()),
                  if (isUnread) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.unreadDot,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Subject
          Text(
            subject,
            style: AppTypography.h4().copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // Preview
          Text(
            preview,
            style: AppTypography.helperText(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

