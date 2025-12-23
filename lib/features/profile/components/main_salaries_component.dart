import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../model/main_salary_model.dart';

class MainSalariesComponent extends StatelessWidget {
  final SingleSalaryModel salary;
  final VoidCallback viewMore;
  const MainSalariesComponent({super.key, required this.salary, required this.viewMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              Expanded(
                child: Text(salary.month, style: AppTypography.p16()),
              ),
              if (salary.isLatest)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.lightGreen, borderRadius: BorderRadius.circular(4)),
                  child: Text('Latest', style: AppTypography.helperTextSmall(color: AppColors.green)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Net Pay', style: AppTypography.helperText()),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(salary.netPay, style: AppTypography.h3()),
              GestureDetector(
                onTap: viewMore,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.backgroundColor, borderRadius: BorderRadius.circular(4)),
                  child: Text('View More', style: AppTypography.p12(color: AppColors.darkText)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}