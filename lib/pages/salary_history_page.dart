import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_constants.dart';
import '../widgets/base_scaffold.dart';
import '../widgets/secondary_app_bar.dart';
import '../widgets/filter_select_field.dart';
import 'salary_detail_page.dart';

class SalaryHistoryPage extends StatefulWidget {
  const SalaryHistoryPage({super.key});

  @override
  State<SalaryHistoryPage> createState() => _SalaryHistoryPageState();
}

class _SalaryHistoryPageState extends State<SalaryHistoryPage> {
  String selectedMonth = '';
  
  // Generate last 12 completed months
  List<String> get availableMonths {
    final now = DateTime.now();
    final lastCompletedMonth = DateTime(now.year, now.month - 1);
    final months = <String>[];
    
    for (int i = 0; i < 12; i++) {
      final date = DateTime(lastCompletedMonth.year, lastCompletedMonth.month - i);
      months.add(_formatMonth(date));
    }
    
    return months;
  }
  
  String _formatMonth(DateTime date) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  @override
  void initState() {
    super.initState();
    selectedMonth = availableMonths.first;
  }

  final List<Map<String, dynamic>> salaryHistory = [
    {
      'month': 'September 2025',
      'netPay': '£8,500',
      'isLatest': true,
      'details': {
        'baseSalary': '£7,000',
        'allowances': '£1,200',
        'overtime': '£800',
        'incomeTax': '-£300',
        'nationalInsurance': '-£200',
        'grossPay': '£9,000',
        'netPay': '£8,500',
        'paymentMethod': 'Direct Bank Transfer',
        'depositedOn': '30 September',
      }
    },
    {
      'month': 'August 2025',
      'netPay': '£7,500',
      'isLatest': false,
      'details': {
        'baseSalary': '£7,000',
        'allowances': '£800',
        'overtime': '£200',
        'incomeTax': '-£280',
        'nationalInsurance': '-£220',
        'grossPay': '£8,000',
        'netPay': '£7,500',
        'paymentMethod': 'Direct Bank Transfer',
        'depositedOn': '30 August',
      }
    },
    {
      'month': 'July 2025',
      'netPay': '£8,500',
      'isLatest': false,
      'details': {
        'baseSalary': '£7,000',
        'allowances': '£1,200',
        'overtime': '£800',
        'incomeTax': '-£300',
        'nationalInsurance': '-£200',
        'grossPay': '£9,000',
        'netPay': '£8,500',
        'paymentMethod': 'Direct Bank Transfer',
        'depositedOn': '30 July',
      }
    },
    {
      'month': 'June 2025',
      'netPay': '£8,500',
      'isLatest': false,
      'details': {
        'baseSalary': '£7,000',
        'allowances': '£1,200',
        'overtime': '£800',
        'incomeTax': '-£300',
        'nationalInsurance': '-£200',
        'grossPay': '£9,000',
        'netPay': '£8,500',
        'paymentMethod': 'Direct Bank Transfer',
        'depositedOn': '30 June',
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      currentNavIndex: 2, // Profile section
      backgroundColor: AppColors.backgroundColor,
      appBar: const SecondaryAppBar(
        title: 'Salary History',
        showBackButton: true,
        notificationCount: AppColors.globalNotificationCount,
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
              // Stats Section
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.currency_pound,
                      label: 'Base Salary',
                      value: '£8,500',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.trending_up,
                      label: 'Latest Salary',
                      value: '£9,500',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionMargin),
              
              // Month Filter
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.darkText,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text('Select Month', style: AppTypography.helperText()),
                  const SizedBox(width: 12),
                  Flexible(
                    child: FilterSelectField(
                      label: '',
                      value: selectedMonth,
                      options: availableMonths,
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sectionMargin),
              
              // Past Salaries Section
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/money.svg',
                    width: 20,
                    height: 20,
                    color: AppColors.darkText,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Past Salaries',
                    style: AppTypography.p16(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Salary List
              ...salaryHistory.map((salary) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildSalaryCard(salary),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkBackgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
        boxShadow: AppShadows.defaultShadow,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColors.darkText,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTypography.helperText(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.h3(),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryCard(Map<String, dynamic> salary) {
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
                child: Text(
                  salary['month'],
                  style: AppTypography.p16(),
                ),
              ),
              if (salary['isLatest'])
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Latest',
                    style: AppTypography.helperTextSmall(
                      color: AppColors.green,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Net Pay',
            style: AppTypography.helperText(),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                salary['netPay'],
                style: AppTypography.h3(),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SalaryDetailPage(
                        salary: salary,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'View More',
                    style: AppTypography.p12(color: AppColors.darkText),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

