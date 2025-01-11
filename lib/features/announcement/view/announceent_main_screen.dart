import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/features/announcement/model/announcements_model.dart';
import 'package:smart_vision/features/announcement/view_model/cubit/announcement_cubit.dart';

import '../../../core/utils/colors.dart';
import 'announcement_details_screen.dart';

class AnnouncementMainScreen extends StatelessWidget {
  const AnnouncementMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          builder: (context, state) {
            var cubit = AnnouncementCubit.get(context);
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 40),
                  child: RefreshIndicator(
                    onRefresh: () => cubit.getAllAnnouncements(context),
                    child: ListView.builder(
                      itemCount: cubit.announcements.length,
                      itemBuilder: (context, index) {
                        AnnouncementsModel ann = cubit.announcements[index];
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
                                  Expanded(child: Text(ann.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.darkColor, fontSize: 16))),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementDetailsScreen(announcement: ann))),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.mainColor.withOpacity(0.8),
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