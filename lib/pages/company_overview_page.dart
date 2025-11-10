import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';

class CompanyOverviewPage extends StatelessWidget {
  const CompanyOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const SecondaryAppBar(
        title: 'Company Overview',
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
                // About Section
                _buildAboutSection(),
                const SizedBox(height: 20),
                
                // Contact Information Section
                _buildContactInfoSection(),
                const SizedBox(height: 20),
                
                // Our Values Section
                _buildValuesSection(),
                const SizedBox(height: 20),
                
                // Employee Benefits Section
                _buildBenefitsSection(),
                const SizedBox(height: 20),
                
                // Mission Statement Section
                _buildMissionSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
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
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkText,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.business,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'About Smart Vision Group',
                style: AppTypography.h4(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            'Smart Vision Group for engineering services, established in Sharjah, UAE, in 2013, is an engineering consultancy firm with branches in Dubai, Sharjah, Abu Dhabi, and Egypt. Specializing in comprehensive engineering solutions for various types of properties, our team of professional engineers is dedicated to transforming visions into reality with precision and care. We are committed to excellence and maintain the highest standards in all sectors of engineering consultancy.',
            style: AppTypography.body14(),
          ),
          const SizedBox(height: 24),
          
          // Company Stats
          Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  label: 'Founded',
                  value: '2013',
                ),
              ),
              Expanded(
                child: _buildStatColumn(
                  label: 'Employees',
                  value: '500+',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatColumn(
                  label: 'Industry',
                  value: 'Engineering',
                ),
              ),
              Expanded(
                child: _buildStatColumn(
                  label: 'Headquarters',
                  value: 'Sharjah, UAE',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
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
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkText,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.phone,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Contact Information',
                style: AppTypography.h4(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Website
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.language,
                color: AppColors.helperText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'www.techcorpsolutions.com',
                  style: AppTypography.p16(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Phone
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.phone_outlined,
                color: AppColors.helperText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '+1 (555) 100-2000',
                  style: AppTypography.p16(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Email
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.email_outlined,
                color: AppColors.helperText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'info@techcorpsolutions.com',
                  style: AppTypography.p16(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Global Offices
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.helperText,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Global Offices',
                      style: AppTypography.p16(),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildLocationChip('Sharjah'),
                        _buildLocationChip('Cairo'),
                        _buildLocationChip('Dubai'),
                        _buildLocationChip('Abu Dhabi'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection() {
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
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkText,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.star,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Our Values',
                style: AppTypography.h4(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Values List
          _buildValueItem(
            'Innovation',
            'We push boundaries and embrace new technologies to create cutting-edge solutions.',
          ),
          const SizedBox(height: 16),
          _buildValueItem(
            'Collaboration',
            'We believe in the power of teamwork and open communication across all levels.',
          ),
          const SizedBox(height: 16),
          _buildValueItem(
            'Excellence',
            'We strive for the highest quality in everything we do, from products to service.',
          ),
          const SizedBox(height: 16),
          _buildValueItem(
            'Integrity',
            'We conduct business with honesty, transparency, and ethical standards.',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
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
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkText,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Employee Benefits',
                style: AppTypography.h4(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Benefits List
          _buildBulletPoint('Comprehensive health insurance'),
          _buildBulletPoint('Flexible work arrangements'),
          _buildBulletPoint('Professional development budget'),
          _buildBulletPoint('Generous paid time off'),
          _buildBulletPoint('Stock option program'),
          _buildBulletPoint('Wellness programs'),
          _buildBulletPoint('Free meals and snacks'),
          _buildBulletPoint('Modern office spaces'),
        ],
      ),
    );
  }

  Widget _buildMissionSection() {
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
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.darkText,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.flag,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Mission Statement',
                style: AppTypography.h4(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Mission Text
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.dividerLight,
                width: 1,
              ),
            ),
            child: Text(
              '"To empower businesses worldwide through innovative technology solutions that drive growth, efficiency, and success. We are committed to creating value for our clients, employees, and communities while maintaining the highest standards of integrity and excellence."',
              style: AppTypography.body14(color: AppColors.darkText).copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
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

  Widget _buildLocationChip(String location) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
      ),
      child: Text(
        location,
        style: AppTypography.p12(),
      ),
    );
  }

  Widget _buildValueItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.p16(),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: AppTypography.helperText(),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.darkText,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTypography.body14(),
            ),
          ),
        ],
      ),
    );
  }
}
