import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';

class AnnouncementDetailPage extends StatelessWidget {
  final Map<String, dynamic> announcement;

  const AnnouncementDetailPage({
    super.key,
    required this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const SecondaryAppBar(
        title: 'Announcement',
        showBackButton: true,
        notificationCount: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                boxShadow: AppShadows.defaultShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag
                  _buildTagChip(announcement['tag']),
                  const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    announcement['title'],
                    style: AppTypography.h3(),
                  ),
                  const SizedBox(height: 12),
                  
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.helperText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        announcement['date'],
                        style: AppTypography.helperText(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Full Description
                  Text(
                    announcement['fullDescription'],
                    style: AppTypography.body14(),
                  ),
                  
                  // Attachment Section
                  if (announcement['attachment'] != null) ...[
                    const SizedBox(height: 32),
                    Text(
                      'Attachment',
                      style: AppTypography.h4(),
                    ),
                    const SizedBox(height: 12),
                    _buildAttachmentCard(announcement['attachment']),
                  ],
                ],
              ),
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
      ),
      child: Text(
        tag,
        style: AppTypography.p12(color: textColor),
      ),
    );
  }

  Widget _buildAttachmentCard(Map<String, String> attachment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
      ),
      child: Row(
        children: [
          // PDF Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          
          // File Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment['name'] ?? '',
                  style: AppTypography.p14(),
                ),
                const SizedBox(height: 2),
                Text(
                  attachment['type'] ?? '',
                  style: AppTypography.helperTextSmall(),
                ),
              ],
            ),
          ),
          
          // Download Button
          IconButton(
            icon: const Icon(
              Icons.download_outlined,
              color: AppColors.darkText,
              size: 24,
            ),
            onPressed: () {
              // Handle download
            },
          ),
        ],
      ),
    );
  }
}

