import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import 'personal_information_page.dart';
import 'company_overview_page.dart';
import 'announcements_page.dart';
import 'salary_history_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const SecondaryAppBar(
        title: 'Profile',
        showBackButton: false,
        notificationCount: 0,
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
                          Text(
                            'Salma Ali',
                            style: AppTypography.h3(),
                          ),
                          const SizedBox(height: 4),
                          
                          // ID
                          Text(
                            'SVG-014',
                            style: AppTypography.p12(color: AppColors.lightText),
                          ),
                          const SizedBox(height: 24),
                          
                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem('Heading', 'Lorem Ipsum'),
                              Container(
                                width: 1,
                                height: 40,
                                color: AppColors.dividerLight,
                              ),
                              _buildStatItem('Heading', 'Lorem Ipsum'),
                              Container(
                                width: 1,
                                height: 40,
                                color: AppColors.dividerLight,
                              ),
                              _buildStatItem('Heading', 'Lorem Ipsum'),
                            ],
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
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCF0F0),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: 60,
                            color: AppColors.lightText.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Menu Items
                _buildMenuItem(
                  context,
                  iconPath: 'assets/icons/personal_id.svg',
                  title: 'Personal Information',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalInformationPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                _buildMenuItem(
                  context,
                  iconPath: 'assets/icons/money.svg',
                  title: 'Salary History',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SalaryHistoryPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                _buildMenuItem(
                  context,
                  iconPath: 'assets/icons/speaker.svg',
                  title: 'Announcements',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnnouncementsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                _buildMenuItem(
                  context,
                  iconPath: 'assets/icons/company.svg',
                  title: 'Company Overview',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompanyOverviewPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                
                _buildMenuItem(
                  context,
                  iconPath: 'assets/icons/logout.svg',
                  title: 'Logout',
                  isLogout: true,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.p12(color: AppColors.lightText),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.p12(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
          boxShadow: AppShadows.defaultShadow,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isLogout ? AppColors.red : AppColors.darkText,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: AppTypography.p14(
                  color: isLogout ? AppColors.red : AppColors.darkText,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isLogout ? AppColors.red : AppColors.lightText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
                Text(
                  'Logout Confirmation',
                  style: const TextStyle(
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
                    onPressed: () {
                      Navigator.pop(context);
                      // Perform logout action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged out successfully')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.getAccentColor(CompanyTheme.groupCompany),
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
                          color: Colors.black.withOpacity(0.10),
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

