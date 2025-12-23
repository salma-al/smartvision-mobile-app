import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import 'personal_info_component.dart';

class PersonalDepartmentComponent extends StatelessWidget {
  final String title, dep, manager, manTitle, manMail, location;
  const PersonalDepartmentComponent({
    super.key, 
    required this.title, 
    required this.dep, 
    required this.manager, 
    required this.manTitle, 
    required this.manMail, 
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
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
          InfoColumn(label: 'Job Title', value: title),
          const SizedBox(height: 16),
          InfoColumn(label: 'Department', value: dep),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Direct Manager', style: AppTypography.helperTextLarge()),
              const SizedBox(height: 1.5),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF39383C),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          manager != '-' ? manager.substring(0, 2) : '-',
                          style: AppTypography.p14(color: AppColors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(manager, style: AppTypography.p16()),
                          const SizedBox(height: 1.5),
                          Text(manTitle, style: AppTypography.helperText()),
                          const SizedBox(height: 1.5),
                          Text(manMail, style: AppTypography.helperText()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                  Text('Location', style: AppTypography.helperTextLarge()),
                  const SizedBox(height: 1.5),
                  Text(location, style: AppTypography.p16()),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}