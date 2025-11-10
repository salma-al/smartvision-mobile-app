import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';

class SalaryDetailPage extends StatelessWidget {
  final Map<String, dynamic> salary;
  
  const SalaryDetailPage({
    super.key,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    final details = salary['details'] as Map<String, dynamic>;
    
    return BaseScaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const SecondaryAppBar(
        title: 'Salary Details',
        showBackButton: true,
        notificationCount: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePaddingHorizontal,
            vertical: AppSpacing.pagePaddingVertical,
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
                      decoration: BoxDecoration(
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
                              salary['month'],
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
                          // Earnings Section
                    Text(
                      'Earnings',
                      style: const TextStyle(
                        fontFamily: "DM Sans",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 25.5 / 17,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Base Salary', details['baseSalary']),
                    const SizedBox(height: 12),
                    _buildDetailRow('Allowances', details['allowances']),
                    const SizedBox(height: 12),
                    _buildDetailRow('Overtime', details['overtime']),
                    
                    // Divider
                    const SizedBox(height: 20),
                    Container(
                      height: 1.173,
                      color: const Color(0xFFD1D5DC),
                    ),
                    const SizedBox(height: 20),
                    
                    // Deductions Section
                    Text(
                      'Deductions',
                      style: const TextStyle(
                        fontFamily: "DM Sans",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 25.5 / 17,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      'Income Tax',
                      details['incomeTax'],
                      isNegative: true,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      'National Insurance',
                      details['nationalInsurance'],
                      isNegative: true,
                    ),
                    
                    // Divider
                    const SizedBox(height: 20),
                    Container(
                      height: 1.173,
                      color: const Color(0xFFD1D5DC),
                    ),
                    const SizedBox(height: 20),
                    
                    // Gross Pay
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Gross Pay',
                          style: const TextStyle(
                            fontFamily: "DM Sans",
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height: 25.5 / 17,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          details['grossPay'],
                          style: AppTypography.h3(),
                        ),
                      ],
                    ),
                    
                    // Divider
                    const SizedBox(height: 20),
                    Container(
                      height: 1.173,
                      color: const Color(0xFFD1D5DC),
                    ),
                    const SizedBox(height: 20),
                    
                    // Net Pay
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Net Pay',
                          style: const TextStyle(
                            fontFamily: "DM Sans",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            height: 27 / 18,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          details['netPay'],
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
              
              // Payment Method (Separate Container)
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
                    Text(
                      'Payment Method',
                      style: const TextStyle(
                        fontFamily: "DM Sans",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 25.5 / 17,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      details['paymentMethod'],
                      style: AppTypography.body14(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Deposited on ${details['depositedOn']}',
                      style: AppTypography.helperText(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isNegative = false}) {
    return Row(
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
    );
  }
}

