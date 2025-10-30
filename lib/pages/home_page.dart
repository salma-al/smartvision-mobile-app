import 'package:flutter/material.dart';
import 'package:untitled1/pages/leave_request_page.dart';
import '../constants/app_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_scaffold.dart';
import 'attendance_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCheckedIn = true;
  String checkInTime = "03:45:33";
  int notificationCount = 2;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePaddingHorizontal,
              vertical: AppSpacing.pagePaddingVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(),
                const SizedBox(height: AppSpacing.sectionMargin),
                
                // Check-in CTA Widget
                _buildCheckInWidget(),
                const SizedBox(height: AppSpacing.sectionMargin),
                
                // My Activity Section
                _buildMyActivitySection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Salma Ali',
              style: AppTypography.h3(),
            ),
            const SizedBox(height: 4),
            Text(
              '28 Sep, Sunday',
              style: AppTypography.p12(color: AppColors.lightText),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              'assets/icons/bell.svg',
              width: 16,
              height: 18.5,
              color: AppColors.darkText,
            ),
            if (notificationCount > 0)
              Positioned(
                right: -6,
                top: -10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.notificationBadgeColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '$notificationCount',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckInWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCheckedIn = !isCheckedIn;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.getAccentColor(CompanyTheme.groupCompany),
          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          boxShadow: AppShadows.checkInShadow,
        ),
        child: Stack(
          children: [
            // Background icon with opacity
            Positioned(
              right: 20,
              top: 20,
              child: Opacity(
                opacity: 0.12,
                child: Icon(
                  Icons.login_outlined,
                  color: AppColors.white,
                  size: 60,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  width: 63,
                  height: 63,
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.38),
                    borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
                  ),
                  child: const Icon(
                    Icons.login_outlined,
                    color: AppColors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCheckedIn ? 'Checked in' : 'Check in',
                        style: isCheckedIn ? AppTypography.checkInStatus() : AppTypography.checkInTime(),
                      ),
                      if (isCheckedIn)
                        Text(
                          checkInTime,
                          style: AppTypography.checkInTime(),
                        ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.white,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Activity',
          style: AppTypography.myActivityTitle(),
        ),
        const SizedBox(height: AppSpacing.sameSectionMargin),
         LayoutBuilder(
           builder: (context, constraints) {
             final itemWidth = (constraints.maxWidth - 12) / 2; // 2 columns + spacing
             return Wrap(
               spacing: 12, // horizontal spacing
               runSpacing: 12, // vertical spacing
               children: [
                 _buildSizedActivityCard(
                   itemWidth,
                   'Attendance',
                   SvgPicture.asset(
                     'assets/icons/calendar.svg',
                     width: 32,
                     height: 32,
                     color: AppColors.green,
                   ),
                   AppColors.green,
                 ),
                 _buildSizedActivityCard(
                   itemWidth,
                   'Leave Requests',
                   SvgPicture.asset(
                     'assets/icons/palm_tree.svg',
                     width: 32,
                     height: 32,
                     color: AppColors.blue,
                   ),
                   AppColors.blue,
                 ),
                 _buildSizedActivityCard(
                   itemWidth,
                   'Overtime Requests',
                   SvgPicture.asset(
                     'assets/icons/clock_plus.svg',
                     width: 32,
                     height: 32,
                     color: AppColors.purple,
                   ),
                   AppColors.purple,
                 ),
                 _buildSizedActivityCard(
                   itemWidth,
                   'Shift Requests',
                   SvgPicture.asset(
                     'assets/icons/case.svg',
                     width: 35,
                     height: 35,
                     color: AppColors.pink,
                   ),
                   AppColors.pink,
                 ),
                 _buildSizedActivityCard(
                   itemWidth,
                   'Requests Approval',
                   SvgPicture.asset(
                     'assets/icons/check.svg',
                     width: 32,
                     height: 32,
                     color: AppColors.orange,
                   ),
                   AppColors.orange,
                   badgeCount: 2,
                 ),
                 _buildSizedActivityCard(
                   itemWidth,
                   'Follow Up',
                   SvgPicture.asset(
                     'assets/icons/note.svg',
                     width: 32,
                     height: 32,
                     color: AppColors.teal,
                   ),
                   AppColors.teal,
                 ),
                 _buildSizedActivityCard(
                   itemWidth,
                   'Inbox',
                   SvgPicture.asset(
                     'assets/icons/mail.svg',
                     width: 27,
                     height: 27,
                     color: AppColors.mint,
                   ),
                   AppColors.mint,
                 ),
                 _buildSizedActivityCard(
                   itemWidth,
                   'Meetings',
                   SvgPicture.asset(
                     'assets/icons/camera.svg',
                     width: 27,
                     height: 27,
                     color: AppColors.redOrange,
                   ),
                   AppColors.redOrange,
                 ),
               ],
             );
           },
         ),
      ],
    );
  }

  Widget _buildSizedActivityCard(double width, String title, Widget iconWidget, Color color, {int? badgeCount}) {
    return SizedBox(
      width: width,
      child: _buildActivityCard(title, iconWidget, color, badgeCount: badgeCount),
    );
  }

  Widget _buildActivityCard(String title,   Widget iconWidget, Color color, {int? badgeCount}) {
    return GestureDetector(
      onTap: () {
        if (title == 'Attendance') {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AttendancePage()),
          );
        } else if (title == "Leave Requests"){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LeaveRequestPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigate to $title')),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20, // block padding
          horizontal: 12, // inline padding
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          boxShadow: AppShadows.defaultShadow,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 53,
                  height: 53,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(child: iconWidget),
                      if (badgeCount != null && badgeCount > 0)
                        Positioned(
                          right: -5,
                          top: -5,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.notificationBadgeColor,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$badgeCount',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTypography.p12(),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Bottom island moved to global BaseScaffold
}
