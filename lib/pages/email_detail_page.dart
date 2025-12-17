import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/attachment_card.dart';

class EmailDetailPage extends StatelessWidget {
  final String sender;
  final String senderEmail;
  final String senderInitials;
  final String subject;
  final String content;
  final String time;
  final List<String> tags;
  final bool hasAttachment;
  final List<Map<String, String>>? attachments;

  const EmailDetailPage({
    super.key,
    required this.sender,
    required this.senderEmail,
    required this.senderInitials,
    required this.subject,
    required this.content,
    required this.time,
    this.tags = const [],
    this.hasAttachment = false,
    this.attachments,
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
    return BaseScaffold(
      currentNavIndex: 0,
      appBar: SecondaryAppBar(
        title: 'Inbox',
        notificationCount: AppColors.globalNotificationCount,
        showTitleBadge: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePaddingHorizontal,
                  vertical: AppSpacing.pagePaddingHorizontal,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: AppShadows.popupShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject
                      Text(
                        subject,
                        style: AppTypography.h3().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tags
                      if (tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getTagBackgroundColor(tag),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: _getTagColor(tag),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Sender Info
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.svecColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                senderInitials,
                                style: const TextStyle(
                                  fontSize: 16,
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
                                Text(
                                  sender,
                                  style: AppTypography.p14(
                                    color: AppColors.darkText,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  senderEmail,
                                  style: AppTypography.helperText().copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Time
                      Text(
                        time,
                        style: AppTypography.helperText().copyWith(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Divider
                      const Divider(
                        color: AppColors.dividerLight,
                        height: 1,
                      ),
                      const SizedBox(height: 24),

                      // Email Content
                      Text(
                        content,
                        style: AppTypography.p14(
                          color: AppColors.darkText,
                        ).copyWith(
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Attachments Section
                      if (hasAttachment && attachments != null && attachments!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Attachments',
                          style: AppTypography.p16().copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...attachments!.map((attachment) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AttachmentCard(
                            fileName: attachment['name'] ?? '',
                            fileType: attachment['type'] ?? '',
                            onDownload: () {
                              // Handle download
                            },
                          ),
                        )).toList(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: AppTypography.p14(
          color: AppColors.darkText,
        ).copyWith(
          height: 1.6,
        ),
      ),
    );
  }
}

