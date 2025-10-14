import 'package:flutter/material.dart';

import '../../../core/widgets/dialogs.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/media_query_values.dart';
import '../../profile/view/profile_main_screen.dart';
import '../../attendance/view/attendance_screen.dart';
import '../../notification/view/notifications_screen.dart';
import '../../reports/view/reports_screen.dart';
import '../../check_in_out/view/sign_in_out_screen.dart';
import '../../requests/view/requests_screen.dart';
import '../../leaves/view/leaves_screen.dart';
import '../components/home_card.dart';
import '../components/sign_in_out_card.dart';

class HomeScreen extends StatelessWidget {
  final bool saveToken;
  const HomeScreen({super.key, required this.saveToken});

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
                            color: AppColors.mainColor.withValues(alpha: 0.8),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Welcome to Smart Vision',
                          style: TextStyle(fontSize: 18, color: AppColors.darkColor),
                        ),
                      ],
                    ),
                  ),
                  Image.asset('assets/images/home_logo.png', height: 50, width: 50),
                ],
              ),
              const SizedBox(height: 20),
              // GridView for Options
              GridView.count(
                crossAxisCount: context.width > 600 ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  HomeCard(
                    icon: Icons.description,
                    label: 'Reports',
                    color: AppColors.mainColor.withValues(alpha: 0.8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsScreen())),
                  ),
                  HomeCard(
                    icon: Icons.access_time,
                    label: 'Attendance',
                    color: AppColors.mainColor.withValues(alpha: 0.8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen())),
                  ),
                  HomeCard(
                    icon: Icons.assignment,
                    label: 'Follow Up',
                    color: AppColors.mainColor.withValues(alpha: 0.8),
                    onTap: () => showDialog(context: context, builder: (BuildContext context) => const ComingSoonDialog()),
                  ),
                  HomeCard(
                    icon: Icons.beach_access,
                    label: 'Shift / Leave',
                    color: AppColors.mainColor.withValues(alpha: 0.8),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LeavesScreen())),
                  ),
                  if(instance.showRequests && context.width > 600)
                  HomeCard(
                    label: 'Requests',
                    color: AppColors.mainColor.withValues(alpha: 0.8),
                    icon: Icons.exit_to_app,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestsScreen())),
                  ),
                ],
              ),
              if(instance.showRequests && context.width < 600)
              SignInOutCard(
                label: 'Requests',
                color: AppColors.mainColor.withValues(alpha: 0.8),
                icon: Icons.exit_to_app,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestsScreen())),
              ),
              SignInOutCard(
                label: 'Check in / Check out',
                color: AppColors.mainColor.withValues(alpha: 0.8),
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
        selectedItemColor: AppColors.mainColor.withValues(alpha: 0.8),
        unselectedItemColor: AppColors.darkColor.withValues(alpha: 0.8),
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
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