import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/core/widgets/base_scaffold.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/features/notification/components/notification_component.dart';
import 'package:smart_vision/features/notification/view_model/cubit/notification_cubit.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/secondary_app_bar.dart';
import '../../../core/constants/app_constants.dart';
import '../model/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 0,
      appBar: const SecondaryAppBar(
        title: 'Notifications',
        notificationCount: 0,
        showTitleBadge: true,
        showNotificationIcon: false,
      ),
      body: BlocProvider(
        create: (context) => NotificationCubit()..getNotifications(context),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            var cubit = NotificationCubit.get(context);
            return SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: cubit.notifications.isEmpty
                        ? const Center(child: Text('No notifications'))
                        : RefreshIndicator(
                            onRefresh: () => cubit.getNotifications(context),
                            child: _buildPartitionedList(cubit),
                          ),
                  ),
                  if(cubit.loading) const LoadingWidget(),
                ],
              ),
            );
          }
        )
      ),
    );
  }

  /// Build list with sections: Today, Yesterday, This week, Earlier
  Widget _buildPartitionedList(NotificationCubit cubit) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(Duration(days: todayStart.weekday - 1)); // Monday as start

    final notifications = List.of(cubit.notifications);
    notifications.sort((a, b) {
      final da = _parseDateSafe(a.date);
      final db = _parseDateSafe(b.date);
      return db.compareTo(da);
    });

    final today = <NotificationModel>[];
    final yesterday = <NotificationModel>[];
    final thisWeek = <NotificationModel>[];
    final earlier = <NotificationModel>[];

    for (final n in notifications) {
      final d = _parseDateSafe(n.date);
      final dDay = DateTime(d.year, d.month, d.day);
      final diffDays = todayStart.difference(dDay).inDays;

      if (diffDays == 0) {
        today.add(n);
      } else if (diffDays == 1) {
        yesterday.add(n);
      } else if (dDay.isAfter(weekStart)) {
        thisWeek.add(n);
      } else {
        earlier.add(n);
      }
    }

    final children = <Widget>[];
    void addSection(String title, List<NotificationModel> list) {
      if (list.isEmpty) return;
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Text(title, style: AppTypography.p14()),
        ),
      );
      for (final fcm in list) {
        final dt = _parseDateSafe(fcm.date);
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: NotificationComponent(
              type: fcm.docType,
              title: fcm.title,
              description: fcm.message,
              time: _formatRelativeDays(dt),
            ),
          ),
        );
      }
    }

    addSection('Today', today);
    addSection('Yesterday', yesterday);
    addSection('This week', thisWeek);
    addSection('Earlier', earlier);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: children,
    );
  }

  /// Robust date parsing for strings like:
  /// - yyyy-MM-dd
  /// - yyyy-MM-dd HH:mm:ss
  /// - yyyy/MM/dd
  /// - dd/MM/yyyy
  /// - MM/dd/yyyy
  /// - yyyy-MM-ddTHH:mm:ss
  DateTime _parseDateSafe(String s) {
    if (s.isEmpty) return DateTime.now();
    try {
      // Handles ISO 8601 and simple date formats
      return DateTime.parse(s).toLocal();
    } catch (_) {
      final candidates = <DateFormat>[
        DateFormat('yyyy-MM-dd'),
        DateFormat('yyyy-MM-dd HH:mm:ss'),
        DateFormat('yyyy/MM/dd'),
        DateFormat('dd/MM/yyyy'),
        DateFormat('MM/dd/yyyy'),
        DateFormat('yyyy-MM-ddTHH:mm:ss'),
      ];
      for (final f in candidates) {
        try {
          // Treat parsed times as UTC-less local and normalize to local
          return f.parse(s, true).toLocal();
        } catch (_) {}
      }
      return DateTime.now();
    }
  }

  /// Format as relative days: Today, 1 day ago, 5 days ago
  String _formatRelativeDays(DateTime date) {
    final now = DateTime.now();
    final d0 = DateTime(now.year, now.month, now.day);
    final d1 = DateTime(date.year, date.month, date.day);
    final diffDays = d0.difference(d1).inDays;
    if (diffDays <= 0) return 'Today';
    if (diffDays == 1) return '1 day ago';
    return '$diffDays days ago';
  }
}
