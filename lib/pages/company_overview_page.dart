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
                // About Smart Vision Group Section
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
                _buildMissionStatementSection(),
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
                  Icons.info_outline,
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
          
          // Description Text
          Text(
            'Smart Vision Group for engineering services, established in Sharjah, UAE, in 2013, is an engineering consultancy firm with branches in Dubai, Sharjah, Abu Dhabi, and Egypt. Specializing in comprehensive engineering solutions for various types of properties, our team of professional engineers is dedicated to transforming visions into reality with precision and care. We are committed to excellence and maintain the highest standards in all sectors of engineering consultancy.',
            style: AppTypography.body14(color: AppColors.darkText),
          ),
          const SizedBox(height: 24),
          
          // Company Info Grid
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(
                  label: 'Founded',
                  value: '2015',
                ),
              ),
              Expanded(
                child: _buildInfoColumn(
                  label: 'Employees',
                  value: '2,500+',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(
                  label: 'Industry',
                  value: 'Engineering',
                ),
              ),
              Expanded(
                child: _buildInfoColumn(
                  label: 'Headquarters',
                  value: 'San Francisco, CA',
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
                  Icons.phone_outlined,
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
          _buildContactItem(
            icon: Icons.language,
            text: 'www.techcorpsolutions.com',
          ),
          const SizedBox(height: 12),
          
          // Phone
          _buildContactItem(
            icon: Icons.phone_outlined,
            text: '+1 (555) 100-2000',
          ),
          const SizedBox(height: 12),
          
          // Email
          _buildContactItem(
            icon: Icons.email_outlined,
            text: 'info@techcorpsolutions.com',
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
                      style: AppTypography.p16(color: AppColors.darkText),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildOfficeTag('San Francisco'),
                        _buildOfficeTag('New York'),
                        _buildOfficeTag('London'),
                        _buildOfficeTag('Tokyo'),
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
                  Icons.star_outline,
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
          
          // Innovation
          _buildValueItem(
            title: 'Innovation',
            description: 'We push boundaries and embrace new technologies to create cutting-edge solutions.',
          ),
          const SizedBox(height: 16),
          
          // Collaboration
          _buildValueItem(
            title: 'Collaboration',
            description: 'We believe in the power of teamwork and open communication across all levels.',
          ),
          const SizedBox(height: 16),
          
          // Excellence
          _buildValueItem(
            title: 'Excellence',
            description: 'We strive for the highest quality in everything we do, from products to service.',
          ),
          const SizedBox(height: 16),
          
          // Integrity
          _buildValueItem(
            title: 'Integrity',
            description: 'We conduct business with honesty, transparency, and ethical standards.',
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
                  Icons.card_giftcard_outlined,
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
          _buildBulletItem('Comprehensive health insurance'),
          const SizedBox(height: 8),
          _buildBulletItem('Flexible work arrangements'),
          const SizedBox(height: 8),
          _buildBulletItem('Professional development budget'),
          const SizedBox(height: 8),
          _buildBulletItem('Generous paid time off'),
          const SizedBox(height: 8),
          _buildBulletItem('Stock option program'),
          const SizedBox(height: 8),
          _buildBulletItem('Wellness programs'),
          const SizedBox(height: 8),
          _buildBulletItem('Free meals and snacks'),
          const SizedBox(height: 8),
          _buildBulletItem('Modern office spaces'),
        ],
      ),
    );
  }

  Widget _buildMissionStatementSection() {
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
                  Icons.assignment_outlined,
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
          
          // Mission Quote
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '"To empower businesses worldwide through innovative technology solutions that drive growth, efficiency, and success. We are committed to creating value for our clients, employees, and communities while maintaining the highest standards of integrity and excellence."',
              style: AppTypography.body14(color: AppColors.darkText),
            ),
          ),
        ],
      ),
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

  Widget _buildContactItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: AppColors.helperText,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.p16(color: AppColors.darkText),
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeTag(String location) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        location,
        style: AppTypography.p12(color: AppColors.darkText),
      ),
    );
  }

  Widget _buildValueItem({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.p16(color: AppColors.darkText),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: AppTypography.helperText(),
        ),
      ],
    );
  }

  Widget _buildBulletItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(
            Icons.circle,
            size: 6,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTypography.body14(color: AppColors.darkText),
          ),
        ),
      ],
    );
  }
}

