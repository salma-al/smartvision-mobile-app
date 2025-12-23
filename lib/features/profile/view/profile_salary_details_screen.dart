import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/helper/shared_functions.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../model/salary_details_model.dart';

class ProfileSalaryDetailsScreen extends StatelessWidget {
  final SalaryDetailsModel details;
  const ProfileSalaryDetailsScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 2, // Profile section
      backgroundColor: AppColors.backgroundColor,
      appBar: SecondaryAppBar(
        title: 'Salary Details',
        showBackButton: true,
        notificationCount: DataHelper.unreadNotificationCount,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.pagePaddingVerticalSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Details Container (Single White Container)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  boxShadow: AppShadows.defaultShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pay Period Section (Dark Background Header)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.darkBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppBorderRadius.radius12),
                          topRight: Radius.circular(AppBorderRadius.radius12),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'Pay Period',
                              style: AppTypography.body14(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${getFullMonthName(details.payDate.month)} ${details.payDate.year}',
                              style: AppTypography.h3(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Body Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Earnings',
                            style: TextStyle(
                              fontFamily: "DM Sans",
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 25.5 / 17,
                              color: AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if(details.earnings.isNotEmpty)
                          ...details.earnings.map((e) => DetailRow(label: e.type, value: e.value)),
                          const SizedBox(height: 20),
                          Container(height: 1.173, color: const Color(0xFFD1D5DC)),
                          const SizedBox(height: 20),
                          const Text(
                            'Deductions',
                            style: TextStyle(
                              fontFamily: "DM Sans",
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              height: 25.5 / 17,
                              color: AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if(details.deductions.isNotEmpty)
                          ...details.deductions.map((e) => DetailRow(label: e.type, value: e.value, isNegative: true)),
                          const SizedBox(height: 20),
                          Container(height: 1.173, color: const Color(0xFFD1D5DC)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Gross Pay',
                                style: TextStyle(
                                  fontFamily: "DM Sans",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 25.5 / 17,
                                  color: AppColors.darkText,
                                ),
                              ),
                              Text(details.grossPay, style: AppTypography.h3()),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(height: 1.173, color: const Color(0xFFD1D5DC)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Net Pay',
                                style: TextStyle(
                                  fontFamily: "DM Sans",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  height: 27 / 18,
                                  color: AppColors.darkText,
                                ),
                              ),
                              Text(
                                details.netPay,
                                style: const TextStyle(
                                  fontFamily: "DM Sans",
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  height: 39 / 26,
                                  color: AppColors.darkText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                  boxShadow: AppShadows.defaultShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontFamily: "DM Sans",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 25.5 / 17,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Deposited on ${details.payDate.day} ${getFullMonthName(details.payDate.month)}', style: AppTypography.helperText()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label, value;
  final bool isNegative;
  const DetailRow({super.key, required this.label, required this.value, this.isNegative = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.helperText(),
          ),
          Text(
            value,
            style: AppTypography.p16(
              color: isNegative ? AppColors.red : AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}