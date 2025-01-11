import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';
import 'package:smart_vision/features/profile/view/profile_main_screen.dart';

import '../../../core/widgets/dialogs.dart';
import '../../attendance/view/attendance_screen.dart';
import '../../notification/view/notifications_screen.dart';
import '../../reports/view/reports_screen.dart';
import '../../check_in_out/view/sign_in_out_screen.dart';
import '../../leaves/view/leaves_screen.dart';
import '../components/home_card.dart';
import '../components/sign_in_out_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instance = DataHelper.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 70, left: 24, right: 24),
        height: context.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Welcome Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello\n${instance.name}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainColor.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text('Welcome to Smart Vision', style: TextStyle(fontSize: 18, color: AppColors.darkColor)),
                      ],
                    ),
                  ),
                  Image.asset('assets/images/home_logo.png', height: 50, width: 50),
                ],
              ),
              const SizedBox(height: 50),
              // GridView for Options
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeCard(
                    icon: Icons.description,
                    label: 'Reports',
                    color: AppColors.mainColor.withOpacity(0.8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsScreen())),
                  ),
                  HomeCard(
                    icon: Icons.access_time,
                    label: 'Attendance',
                    color: AppColors.mainColor.withOpacity(0.8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen())),
                  ),
                  // HomeCard(
                  //   icon: Icons.assignment,
                  //   label: 'Follow Up',
                  //   color: AppColors.mainColor.withOpacity(0.8),
                  //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectsScreen())),
                  // ),
                  HomeCard(
                    icon: Icons.assignment,
                    label: 'Follow Up',
                    color: AppColors.mainColor.withOpacity(0.8),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ComingSoonDialog();
                        },
                      );
                    },
                  ),
                  HomeCard(
                    icon: Icons.beach_access,
                    label: 'Shift / Leave',
                    color: AppColors.mainColor.withOpacity(0.8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestScreen())),
                  ),
                ],
              ),
              // Sign In/Out button combined
              SignInOutCard(
                label: 'Check in / Check out',
                color: AppColors.mainColor.withOpacity(0.8),
                icon: Icons.exit_to_app,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInOutScreen())),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 8,
        currentIndex: 0,
        selectedItemColor: AppColors.mainColor.withOpacity(0.8),
        unselectedItemColor: AppColors.darkColor.withOpacity(0.8),
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: InkWell(
              child: const Icon(Icons.home_filled), 
              onTap: () {},
            ), 
            label: 'Home', 
            backgroundColor: AppColors.mainColor,
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
              child: const Icon(Icons.notifications),
            ), 
            label: 'Notifications', 
            backgroundColor: AppColors.mainColor,
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileMainScreen())), 
              child: const Icon(Icons.person),
            ), 
            label: 'Profile', 
            backgroundColor: AppColors.mainColor,
          ),
        ],
      ),
    );
  }
}