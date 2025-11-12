import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/utils/colors.dart';
import '../../../core/widgets/loading_widget.dart';
import '../model/announcements_model.dart';
import '../view_model/cubit/announcement_cubit.dart';
import 'announcement_details_screen.dart';

class AnnouncementMainScreen extends StatelessWidget {
  const AnnouncementMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Announcement', style: TextStyle(color: AppColors.mainColor)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.white,
        actions: [
          Image.asset('assets/images/home_logo.png', width: 40, height: 40),
          const SizedBox(width: 15),
        ],
      ),
      body: BlocProvider(
        create: (context) => AnnouncementCubit()..getAllAnnouncements(context),
        child: BlocBuilder<AnnouncementCubit, AnnouncementState>(
          builder: (ctx, state) {
            return Stack(
              children: [
                if(state is AnnouncementLoaded)
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
                  child: RefreshIndicator(
                    onRefresh: () => ctx.read<AnnouncementCubit>().getAllAnnouncements(ctx),
                    child: ListView.builder(
                      itemCount: state.announcements.length,
                      itemBuilder: (context, index) {
                        AnnouncementsModel ann = state.announcements[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Text(ann.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.mainColor, fontSize: 18))),
                                  const SizedBox(width: 12),
                                  Text(ann.date, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Html(
                                      data: ann.description,
                                      style: {
                                        "body": Style(
                                          maxLines: 1,
                                          textOverflow: TextOverflow.ellipsis,
                                        ),
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementDetailsScreen(announcement: ann))),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Text('Details', style: TextStyle(color: Colors.white, fontSize: 14))),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if(state is AnnouncementLoading)
                const LoadingWidget(),
              ],
            );
          }
        )
      ),
    );
  }
}