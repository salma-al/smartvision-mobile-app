import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smart_vision/features/announcement/model/announcements_model.dart';
import 'package:smart_vision/features/announcement/view/announcement_details_screen.dart';

import '../../../core/constants/app_constants.dart';

class AnnouncementCard extends StatelessWidget {
  final AnnouncementsModel announcement;
  const AnnouncementCard({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnnouncementDetailsScreen(announcement: announcement),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
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
                      Expanded(child: Text(announcement.name, style: AppTypography.p16())),
                      if (announcement.isNew)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('New', style: AppTypography.helperTextSmall(color: AppColors.green)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Html(
                    data: announcement.description,
                    style: {
                      "body": Style(
                        maxLines: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: AppColors.helperText),
                      const SizedBox(width: 4),
                      Text(announcement.date, style: AppTypography.helperTextSmall()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.lightText, size: 24),
          ],
        ),
      ),
    );
  }
}