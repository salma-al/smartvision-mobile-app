import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/filter_panel.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../component/announcement_card.dart';
import '../view_model/cubit/announcement_cubit.dart';

class AnnouncementMainScreen extends StatelessWidget {
  const AnnouncementMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnnouncementCubit()..getAllAnnouncements(context),
      child: BaseScaffold(
        currentNavIndex: 2,
        backgroundColor: AppColors.backgroundColor,
        appBar: SecondaryAppBar(
          title: 'Announcement',
          showBackButton: true,
          notificationCount: DataHelper.unreadNotificationCount,
        ),
        body: BlocBuilder<AnnouncementCubit, AnnouncementState>(
          builder: (ctx, state) {
            return RefreshIndicator(
              onRefresh: () => ctx.read<AnnouncementCubit>().getAllAnnouncements(context),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Section
                        FilterPanel(
                          pageTitle: 'Announcement Filters',
                          pageSubtitle: 'View and filter your data',
                          typeLabel: '',
                          typeOptions: const [],
                          onFilter: (from, to, type, status, needAction) => ctx.read<AnnouncementCubit>().getAllAnnouncements(context, from, to),
                        ),
                        const SizedBox(height: 16),
                        // List Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('All Announcements', style: AppTypography.h4()),
                            Text('${ctx.read<AnnouncementCubit>().announcements.length} total',
                                style: AppTypography.helperText()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Announcements
                        ...ctx.read<AnnouncementCubit>().announcements.map((announcement) {
                          return AnnouncementCard(announcement: announcement);
                        }),
                      ],
                    ),
                  ),
                  if(state is AnnouncementLoading) const LoadingWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}