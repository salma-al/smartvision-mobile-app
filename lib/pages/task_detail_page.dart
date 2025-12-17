import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/badge.dart';

class TaskDetailPage extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailPage({
    super.key,
    required this.task,
  });

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

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 0,
      appBar: SecondaryAppBar(
        title: 'Task Details',
        showBackButton: true,
        notificationCount: AppColors.globalNotificationCount,
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
                      // Title
                      Text(
                        task['title'],
                        style: AppTypography.h3().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Status Badge
                      AppBadge(
                        label: task['status'],
                        color: _getStatusColor(task['status']),
                        backgroundColor: _getStatusBackgroundColor(task['status']),
                      ),
                      const SizedBox(height: 20),

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
                                task['assigneeInitials'],
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
                                  task['name'],
                                  style: AppTypography.p14(
                                    color: AppColors.darkText,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  task['assigneeEmail'],
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
                        task['dateTime'],
                        style: AppTypography.helperText().copyWith(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tag (bordered, no background)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
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
                      const SizedBox(height: 24),

                      // Divider
                      const Divider(
                        color: AppColors.dividerLight,
                        height: 1,
                      ),
                      const SizedBox(height: 24),

                      // Email Content
                      Text(
                        task['content'],
                        style: AppTypography.p14(
                          color: AppColors.darkText,
                        ).copyWith(
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Button
                      InkWell(
                        onTap: () {
                          // Handle action button press
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.getAccentColor(CompanyTheme.groupCompany),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: AppShadows.defaultShadow,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start Work',
                                style: AppTypography.p14(color: AppColors.white),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                size: 18,
                                color: AppColors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
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
}

