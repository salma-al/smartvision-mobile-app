import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/attachment_card.dart';

class MeetingDetailsPage extends StatelessWidget {
  final String title;
  final DateTime date;
  final String time;
  final String duration;
  final List<String> attendees;
  final int colorIndex;

  const MeetingDetailsPage({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.duration,
    required this.attendees,
    required this.colorIndex,
  });

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return AppColors.unreadDot; // Blue
      case 'completed':
        return AppColors.green;
      case 'canceled':
        return AppColors.red;
      default:
        return AppColors.unreadDot;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status.toLowerCase()) {
      case 'planned':
        return AppColors.unreadBg; // Light blue
      case 'completed':
        return AppColors.lightGreen;
      case 'canceled':
        return AppColors.lightRed;
      default:
        return AppColors.unreadBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final meetingColor = AppColors.meetingColors[colorIndex];
    final status = 'Planned'; // This would come from data

    return BaseScaffold(
      currentNavIndex: 0, // Home section
      appBar: const SecondaryAppBar(title: 'Meeting Details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Title and Status Badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.h2(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusBackgroundColor(status),
                      borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                    ),
                    child: Text(
                      status,
                      style: AppTypography.p12(color: _getStatusColor(status)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Date
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.helperText),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(date),
                    style: AppTypography.body14(color: AppColors.darkText),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Time
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: AppColors.helperText),
                  const SizedBox(width: 8),
                  Text(
                    '$time • $duration',
                    style: AppTypography.body14(color: AppColors.darkText),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Divider
              Container(
                height: 1.173,
                color: const Color(0xFFF3F4F6),
              ),
              const SizedBox(height: 20),

              // Department
              Row(
                children: [
                  const Icon(Icons.business_outlined, size: 16, color: AppColors.helperText),
                  const SizedBox(width: 8),
                  Text(
                    'Department',
                    style: AppTypography.helperText(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  'Product Development',
                  style: AppTypography.body14(color: AppColors.darkText),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Divider
              Container(
                height: 1.173,
                color: const Color(0xFFF3F4F6),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Description
              Text(
                'Description',
                style: AppTypography.h4(),
              ),
              const SizedBox(height: 12),
              Text(
                'Monthly product review and planning session',
                style: AppTypography.body14(color: AppColors.darkText),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Divider
              Container(
                height: 1.173,
                color: const Color(0xFFF3F4F6),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Meeting Link
              Row(
                children: [
                  const Icon(Icons.link, size: 16, color: AppColors.helperText),
                  const SizedBox(width: 8),
                  Text(
                    'Meeting Link',
                    style: AppTypography.helperText(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening meeting link...')),
                  );
                },
                child: Text(
                  'https://meet.company.com/product-review-oct6',
                  style: AppTypography.body14(color: AppColors.unreadDot),
                ),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Divider
              Container(
                height: 1.173,
                color: const Color(0xFFF3F4F6),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Meeting Agenda
              Row(
                children: [
                  const Icon(Icons.description_outlined, size: 16, color: AppColors.darkText),
                  const SizedBox(width: 8),
                  Text(
                    'Meeting Agenda',
                    style: AppTypography.h4(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildAgendaItem('Review Q3 product metrics and KPIs'),
              _buildAgendaItem('Discuss upcoming feature releases'),
              _buildAgendaItem('Address customer feedback and pain points'),
              _buildAgendaItem('Plan Q4 product roadmap priorities'),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Divider
              Container(
                height: 1.173,
                color: const Color(0xFFF3F4F6),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Participants
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 16, color: AppColors.darkText),
                  const SizedBox(width: 8),
                  Text(
                    'Participants (${attendees.length})',
                    style: AppTypography.h4(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...attendees.map((initials) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: meetingColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _getFullName(initials),
                        style: AppTypography.body14(color: AppColors.darkText),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Divider
              Container(
                height: 1.173,
                color: const Color(0xFFF3F4F6),
              ),
              const SizedBox(height: AppSpacing.sectionMargin),

              // Meeting Minutes
              Row(
                children: [
                  const Icon(Icons.description_outlined, size: 16, color: AppColors.darkText),
                  const SizedBox(width: 8),
                  Text(
                    'Meeting Minutes',
                    style: AppTypography.h4(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AttachmentCard(
                fileName: 'Product_Review_Minutes.pdf',
                fileType: 'PDF Document',
                onDownload: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading file...')),
                  );
                },
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgendaItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.circle, size: 4, color: AppColors.darkText),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.body14(color: AppColors.darkText),
            ),
          ),
        ],
      ),
    );
  }

  String _getFullName(String initials) {
    // Sample name mapping
    final names = {
      'JD': 'John Doe',
      'SM': 'Sarah Miller',
      'AL': 'Alex Lee',
      'TB': 'Tom Brown',
      'LG': 'Lisa Garcia',
      'KM': 'Kevin Martinez',
      'AR': 'Amy Rodriguez',
      'JS': 'James Smith',
      'DL': 'David Lopez',
      'PK': 'Patricia King',
      'CT': 'Chris Taylor',
      'AP': 'Anna Park',
      'RM': 'Robert Moore',
      'KS': 'Karen Scott',
      'NJ': 'Nancy Johnson',
      'MW': 'Michael Wilson',
      'AB': 'Amanda Brown',
    };
    return names[initials] ?? initials;
  }
}

