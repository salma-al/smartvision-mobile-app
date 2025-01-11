import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';
import '../../../core/utils/colors.dart';
import '../model/announcements_model.dart';

class AnnouncementDetailsScreen extends StatelessWidget {
  final AnnouncementsModel announcement;
  const AnnouncementDetailsScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement Details', style: TextStyle(color: AppColors.mainColor)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: Colors.white,
        actions: [
          Image.asset('assets/images/home_logo.png', width: 40, height: 40),
          const SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(announcement.name, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.mainColor))),
                  const SizedBox(width: 16),
                  Text(announcement.date, style: TextStyle(fontSize: 16, color: AppColors.darkColor)),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                width: context.width,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text('Content', style: TextStyle(fontSize: 16, color: AppColors.mainColor)),
                    const SizedBox(height: 24),
                    Text(announcement.description, style: TextStyle(fontSize: 16, color: AppColors.darkColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}