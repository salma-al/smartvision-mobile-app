// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../../announcement/view/announceent_main_screen.dart';
import '../../login/view/login_screen.dart';
import '../components/main_profile_info.dart';
import '../components/main_profile_item.dart';
import '../view_model/cubit/profile_cubit.dart';
import 'profile_company_brief_screen.dart';
import 'profile_info_screen.dart';
import 'profile_main_salaries.dart';

class ProfileMainScreen extends StatelessWidget {
  const ProfileMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instance = DataHelper.instance;
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileMainData(context),
      child: BaseScaffold(
        currentNavIndex: 2,
        appBar: SecondaryAppBar(
          title: 'Profile',
          showBackButton: false,
          notificationCount: DataHelper.unreadNotificationCount,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePaddingHorizontal,
              ),
              child: Column(
                children: [
                  // Profile Header Card with overlapping avatar
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // White Card
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 60), // Half of avatar height
                        padding: const EdgeInsets.only(top: 70, bottom: 30, left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                          boxShadow: AppShadows.defaultShadow,
                        ),
                        child: Column(
                          children: [
                            // Name
                            Text(instance.name ?? '', style: AppTypography.h3()),
                            const SizedBox(height: 16),
                            // Stats Row
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                if(state is MainProfileLoaded) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      MainProfileInfo(label: 'Shift Hours', value: state.shift),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: AppColors.dividerLight,
                                      ),
                                      MainProfileInfo(label: 'Employee No.', value: instance.userId ?? ''),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: AppColors.dividerLight,
                                      ),
                                      MainProfileInfo(label: "Joined", value: state.join),
                                    ],
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const MainProfileInfo(label: 'Shift Hours', value: ''),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: AppColors.dividerLight,
                                      ),
                                      MainProfileInfo(label: 'Employee No.', value: instance.userId ?? ''),
                                      Container(
                                        width: 1,
                                        height: 40,
                                        color: AppColors.dividerLight,
                                      ),
                                      const MainProfileInfo(label: "Joined", value: ''),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      // Avatar - positioned at top center
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFCF0F0),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_outline,
                              size: 60,
                              color: AppColors.lightText.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Menu Items
                  MainProfileItem(
                    iconPath: 'assets/images/personal_id.svg', 
                    title: 'Personal Information', 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileInfoScreen())),
                  ),
                  const SizedBox(height: 12),
                  MainProfileItem(
                    iconPath: 'assets/images/money.svg', 
                    title: 'Salary History', 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileMainSalary())),
                  ),
                  const SizedBox(height: 12),
                  MainProfileItem(
                    iconPath: 'assets/images/speaker.svg', 
                    title: 'Announcements', 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementMainScreen())),
                  ),
                  const SizedBox(height: 12),
                  MainProfileItem(
                    iconPath: 'assets/images/company.svg', 
                    title: 'Company Overview', 
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanyProfileScreen())),
                  ),
                  const SizedBox(height: 12),
                  MainProfileItem(
                    iconPath: 'assets/images/logout.svg', 
                    title: 'Logout', 
                    isLogout: true,
                    onTap: () => showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                const Text(
                  'Logout Confirmation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    height: 28 / 18,
                    color: AppColors.darkText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Content
                Text(
                  'Are you sure you want to logout? You will need to sign again to access your account.',
                  style: AppTypography.body14(color: AppColors.lightText),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Logout Button (Red, filled)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await DataHelper.instance.reset(true);
                      Navigator.pushAndRemoveUntil(
                        context, 
                        MaterialPageRoute(builder: (_) => const LoginScreen()), 
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DataHelper.instance.comp!.primaryColor,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: AppTypography.p14(color: AppColors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Cancel Button (White, text style)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                        side: BorderSide(
                          color: Colors.black.withValues(alpha: 0.10),
                          width: 1.173,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTypography.p14(color: AppColors.darkText),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}