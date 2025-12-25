import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_vision/core/widgets/dialgs.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import 'package:smart_vision/features/home/view_model/cubit/home_cubit.dart';
import 'package:smart_vision/features/leaves/view/overtime_request_screen.dart';
import 'package:smart_vision/features/leaves/view/shift_request_screen.dart';

import '../../../core/helper/data_helper.dart';
import '../../../core/helper/shared_functions.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../attendance/view/attendance_screen.dart';
import '../../notification/view/notifications_screen.dart';
import '../../requests/view/requests_screen.dart';
import '../../leaves/view/leaves_screen.dart';
import '../components/sign_in_out_card.dart';
import '../components/home_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instance = DataHelper.instance;
    DateTime currentDate = DateTime.now();
    return BlocProvider(
      create: (context) => HomeCubit()..getHomeData(context),
      child: BaseScaffold(
        currentNavIndex: 0,
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if(state is HomeError) ToastWidget().showToast(state.message, context);
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.pagePaddingHorizontal,
                    vertical: AppSpacing.pagePaddingVertical,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, ${instance.name}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTypography.h3(),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${currentDate.day} ${getMonthName(currentDate.month)}, ${getDayName(currentDate.weekday)}',
                                  style: AppTypography.p12(color: AppColors.lightText),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen())),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/bell.svg',
                                  width: 16,
                                  height: 18.5,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.darkText,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                if (DataHelper.unreadNotificationCount > 0)
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
                                        '${DataHelper.unreadNotificationCount}',
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
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sectionMargin),
                      if(state is HomeLoaded)
                      SignInOutCard(
                        isCheckedIn: state.home.lastCheckIn.isNotEmpty, 
                        checkInTime: state.home.lastCheckIn,
                        onPopOut: () => context.read<HomeCubit>().getHomeData(context),
                      )
                      else
                      SignInOutCard(
                        isCheckedIn: false, 
                        checkInTime: '',
                        onPopOut: () => context.read<HomeCubit>().getHomeData(context),
                      ),
                      const SizedBox(height: AppSpacing.sectionMargin),
                      Text('My Activity', style: AppTypography.myActivityTitle()),
                      const SizedBox(height: AppSpacing.sameSectionMargin),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          const HomeCard(
                            title: 'Attendance',
                            color: Color(0xFF19868B),
                            navigateTo: AttendanceScreen(),
                            iconPath: 'assets/images/calendar.svg',
                          ),
                          const HomeCard(
                            title: 'Leave Requests',
                            color: Color(0xFF19868B),
                            navigateTo: LeavesScreen(),
                            iconPath: 'assets/images/palm_tree.svg',
                          ),
                          const HomeCard(
                            title: 'Overtime Requests',
                            color: Color(0xFF19868B),
                            navigateTo: OvertimeRequestScreen(),
                            iconPath: 'assets/images/clock_plus.svg',
                          ),
                          const HomeCard(
                            title: 'Shift Requests',
                            color: Color(0xFF19868B),
                            navigateTo: ShiftRequestScreen(),
                            iconPath: 'assets/images/case.svg',
                          ),
                          if (state is HomeLoaded && state.home.showRequests)
                            HomeCard(
                              title: 'Requests Approval',
                              color: const Color(0xFF19868B),
                              navigateTo: const RequestsScreen(),
                              iconPath: 'assets/images/check.svg',
                              badgeCount: state.home.unreadRequestsCount,
                            ),
                          // const HomeCard(
                          //   title: 'Follow Up',
                          //   color: Color(0xFF19868B),
                          //   navigateTo: ComingSoonDialog(),
                          //   iconPath: 'assets/images/note.svg',
                          // ),
                          HomeCard(
                            title: 'Inbox',
                            color: const Color(0xFF19868B),
                            navigateTo: const ComingSoonDialog(),
                            iconPath: 'assets/images/mail.svg',
                            badgeCount: state is HomeLoaded ? state.home.unreadEmailsCount : 0,
                          ),
                          const HomeCard(
                            title: 'Meetings',
                            color: Color(0xFF19868B),
                            navigateTo: ComingSoonDialog(),
                            iconPath: 'assets/images/camera.svg',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
