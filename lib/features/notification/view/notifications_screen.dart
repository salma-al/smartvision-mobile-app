import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/features/announcement/model/announcements_model.dart';
import 'package:smart_vision/features/announcement/view/announcement_details_screen.dart';
import 'package:smart_vision/features/notification/view_model/cubit/notification_cubit.dart';
import 'package:smart_vision/features/profile/view/profile_main_screen.dart';

import '../../../core/utils/colors.dart';
import '../../home/view/home_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: AppColors.mainColor)),
        actions: [
          Image.asset('assets/images/home_logo.png', width: 40, height: 40),
          const SizedBox(width: 15),
        ],
        backgroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => NotificationCubit()..getNotifications(context),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            var cubit = NotificationCubit.get(context);
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: cubit.notifications.isEmpty ? const Center(child: Text('No notifications')) : 
                  RefreshIndicator(
                    onRefresh: () => cubit.getNotifications(context),
                    child: ListView.builder(
                      itemCount: cubit.notifications.length,
                      itemBuilder: (context, index) {
                        var fcm = cubit.notifications[index];
                        return InkWell(
                          onTap: fcm.docType.toLowerCase() == 'announcement' ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => AnnouncementDetailsScreen(
                            announcement: AnnouncementsModel(date: fcm.date, name: fcm.title, description: fcm.message, attachments: [])))) : () {},
                          child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      fcm.docType.toLowerCase() == 'announcement' ? 'New Announcement' : fcm.title, 
                                      maxLines: 2, 
                                      overflow: TextOverflow.ellipsis, 
                                      style: TextStyle(color: AppColors.mainColor, fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      fcm.date, 
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis, 
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: AppColors.darkColor, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(fcm.docType.toLowerCase() == 'announcement' ? fcm.title : fcm.message, style: TextStyle(color: AppColors.darkColor, fontSize: 16)),
                            ],
                          ),
                                                ),
                        );
                      },
                    ),
                  ),
                ),
                if(cubit.loading)
                const LoadingWidget(),
              ],
            );
          }
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: 1,
        selectedItemColor: AppColors.mainColor.withValues(alpha: 0.8),
        unselectedItemColor: AppColors.darkColor.withValues(alpha: 0.8),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(saveToken: false)));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileMainScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}