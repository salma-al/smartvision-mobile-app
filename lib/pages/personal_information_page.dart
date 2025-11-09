import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const SecondaryAppBar(
        title: 'Personal Information',
        showBackButton: true,
        notificationCount: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                // Personal Information Section
                _buildPersonalInfoSection(),
                const SizedBox(height: 20),
                
                // Department Information Section
                _buildDepartmentInfoSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar, Name, Number, Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circle Avatar
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF39383C),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'SA',
                    style: AppTypography.h3(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Name, Number, Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Salma Ali',
                      style: AppTypography.p16(),
                    ),
                    const SizedBox(height: 1.5),
                    Text(
                      'SVG-014',
                      style: AppTypography.helperText(),
                    ),
                    const SizedBox(height: 4),
                    
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Active',
                        style: AppTypography.p12(color: AppColors.green),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Work Email (one column)
          _buildInfoRow(
            label: 'Work Email',
            value: 'salmafouad@gmartvgroup.com',
          ),
          const SizedBox(height: 16),
          
          // Default Shift and Break Hours (two columns)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoColumn(
                  label: 'Default Shift',
                  value: '9 AM - 6 PM',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoColumn(
                  label: 'Break Hours',
                  value: '1 PM - 2 PM',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Join Date and Employment Type (two columns)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoColumn(
                  label: 'Join Date',
                  value: 'Sep 01, 2025',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoColumn(
                  label: 'Employment Type',
                  value: '-',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title with Icon
          Row(
            children: [
              // Placeholder for department icon
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkText,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.business_center,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Department Information',
                style: AppTypography.h4(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Job Title
          _buildInfoRow(
            label: 'Job Title',
            value: 'Engineer',
          ),
          const SizedBox(height: 16),
          
          // Department
          _buildInfoRow(
            label: 'Department',
            value: 'Software - SVG',
          ),
          const SizedBox(height: 16),
          
          // Direct Manager Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Direct Manager',
                style: AppTypography.helperTextLarge(),
              ),
              const SizedBox(height: 1.5),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Manager Avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF39383C),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'ME',
                          style: AppTypography.p14(color: AppColors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Manager Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mohamed Momtaz',
                            style: AppTypography.p16(),
                          ),
                          const SizedBox(height: 1.5),
                          Text(
                            'Software Manager',
                            style: AppTypography.helperText(),
                          ),
                          const SizedBox(height: 1.5),
                          Text(
                            'Mohamed@company.com',
                            style: AppTypography.helperText(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.helperText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location',
                    style: AppTypography.helperTextLarge(),
                  ),
                  const SizedBox(height: 1.5),
                  Text(
                    'Cairo, Egypt',
                    style: AppTypography.p16(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.helperTextLarge(),
        ),
        const SizedBox(height: 1.5),
        Text(
          value,
          style: AppTypography.p16(),
        ),
      ],
    );
  }

  Widget _buildInfoColumn({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.helperTextLarge(),
        ),
        const SizedBox(height: 1.5),
        Text(
          value,
          style: AppTypography.p16(),
        ),
      ],
    );
  }
}

