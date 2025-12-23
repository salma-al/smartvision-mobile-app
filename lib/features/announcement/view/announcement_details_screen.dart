import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smart_vision/core/widgets/attachment_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../model/announcements_model.dart';

class AnnouncementDetailsScreen extends StatelessWidget {
  final AnnouncementsModel announcement;
  const AnnouncementDetailsScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 2,
      appBar: SecondaryAppBar(
        title: 'Announcement',
        showBackButton: true,
        notificationCount: DataHelper.unreadNotificationCount,
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
                  Text(
                    announcement.name,
                    style: AppTypography.h3(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.helperText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        announcement.date,
                        style: AppTypography.helperText(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Html(
                    data: announcement.description,
                    onLinkTap: (url, attributes, element) async {
                      if(url == null) return;
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                  ),
                  if (announcement.attachments.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Text(
                      'Attachment',
                      style: AppTypography.h4(),
                    ),
                    const SizedBox(height: 12),
                    ...announcement.attachments.map((attach) => AttachmentWidget(url: attach)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}