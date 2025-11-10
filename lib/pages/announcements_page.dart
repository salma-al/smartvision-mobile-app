import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/filter_panel.dart';
import 'announcement_detail_page.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> announcements = [
    {
      'title': 'System Maintenance Scheduled',
      'description': 'Our systems will undergo scheduled maintenance this weekend. Services may',
      'date': 'Oct 2, 2024',
      'tag': 'System',
      'isNew': true,
      'fullDescription': 'Our systems will undergo scheduled maintenance this weekend. Services may be temporarily unavailable. We apologize for any inconvenience this may cause. The maintenance window is scheduled for Saturday, October 2nd from 2:00 AM to 6:00 AM EST. During this time, you may experience intermittent service disruptions. All systems are expected to be fully operational by 7:00 AM EST.',
      'attachment': {
        'name': 'Maintenance_Schedule.pdf',
        'type': 'PDF Document',
      },
    },
    {
      'title': 'New Employee Benefits',
      'description': 'We\'re excited to announce enhanced health and wellness benefits starting next',
      'date': 'Oct 1, 2024',
      'tag': 'Benefits',
      'isNew': true,
      'fullDescription': 'We\'re excited to announce enhanced health and wellness benefits starting next month. These new benefits include improved healthcare coverage, mental health support, and wellness programs.',
      'attachment': null,
    },
    {
      'title': 'Q4 Company All-Hands Meeting',
      'description': 'Join us for our quarterly all-hands meeting to review progress and discuss upcoming',
      'date': 'Sep 28, 2024',
      'tag': 'HR',
      'isNew': false,
      'fullDescription': 'Join us for our quarterly all-hands meeting to review progress and discuss upcoming initiatives for Q4.',
      'attachment': null,
    },
    {
      'title': 'Security Policy Updates',
      'description': 'Important updates to our security policies and procedures. All employees must review and',
      'date': 'Sep 25, 2024',
      'tag': 'Security',
      'isNew': false,
      'fullDescription': 'Important updates to our security policies and procedures. All employees must review and acknowledge these changes.',
      'attachment': null,
    },
    {
      'title': 'Employee Recognition Program',
      'description': 'Introducing our new peer-to-peer recognition program to celebrate outstanding',
      'date': 'Sep 20, 2024',
      'tag': 'HR',
      'isNew': false,
      'fullDescription': 'Introducing our new peer-to-peer recognition program to celebrate outstanding contributions and achievements.',
      'attachment': null,
    },
  ];

  List<Map<String, dynamic>> get filteredAnnouncements {
    if (selectedCategory == 'All') {
      return announcements;
    }
    return announcements.where((a) => a['tag'] == selectedCategory).toList();
  }

  int get newUpdatesCount =>
      announcements.where((a) => a['isNew'] == true).length;
  
  int get highPriorityCount => 2; // Mock data

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const SecondaryAppBar(
        title: 'Announcement',
        showBackButton: true,
        notificationCount: 0,
      ),
      body: Column(
        children: [
          // Stats Section
          Container(
            color: AppColors.backgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    iconPath: 'assets/icons/bell.svg',
                    label: 'New Updates',
                    count: newUpdatesCount,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    iconPath: 'assets/icons/alert.svg',
                    label: 'High Priority',
                    count: highPriorityCount,
                  ),
                ),
              ],
            ),
          ),
          
          // Filter Section
          Container(
            color: AppColors.backgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: FilterPanel(
              pageTitle: 'Announcement Filters',
              pageSubtitle: 'View and filter your data',
              typeLabel: 'Category',
              typeOptions: const ['All', 'System', 'HR', 'Benefits', 'Security'],
              onFilter: (from, to, type, status, needAction) {
                setState(() {
                  selectedCategory = type;
                });
              },
            ),
          ),
          
          // List Section
          Expanded(
            child: Container(
              color: AppColors.backgroundColor,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Announcements',
                        style: AppTypography.h4(),
                      ),
                      Text(
                        '${filteredAnnouncements.length} total',
                        style: AppTypography.helperText(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  ...filteredAnnouncements.map((announcement) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildAnnouncementCard(announcement),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String iconPath,
    required String label,
    required int count,
  }) {
    // Use red color for alert/high priority icon
    final iconColor = iconPath.contains('alert') 
        ? AppColors.notificationBadgeColor 
        : AppColors.darkText;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            color: iconColor,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.helperText(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: AppTypography.h3(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnnouncementDetailPage(
              announcement: announcement,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          boxShadow: AppShadows.defaultShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          announcement['title'],
                          style: AppTypography.p16(),
                        ),
                      ),
                      if (announcement['isNew'])
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'New',
                            style: AppTypography.helperTextSmall(
                              color: AppColors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    announcement['description'],
                    style: AppTypography.helperText(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.helperText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        announcement['date'],
                        style: AppTypography.helperTextSmall(),
                      ),
                      const SizedBox(width: 12),
                      _buildTagChip(announcement['tag']),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.lightText,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    Color bgColor;
    Color textColor;

    switch (tag) {
      case 'System':
        bgColor = AppColors.lightBlue;
        textColor = AppColors.blue;
        break;
      case 'Benefits':
        bgColor = AppColors.lightYellow;
        textColor = AppColors.yellow;
        break;
      case 'HR':
        bgColor = AppColors.lightGrey;
        textColor = AppColors.darkText;
        break;
      case 'Security':
        bgColor = AppColors.lightRed;
        textColor = AppColors.red;
        break;
      default:
        bgColor = AppColors.lightGrey;
        textColor = AppColors.darkText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        tag,
        style: AppTypography.helperTextSmall(color: textColor),
      ),
    );
  }
}

