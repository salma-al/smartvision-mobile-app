import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/widgets/loading_widget.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/filter_select_field.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../components/main_salaries_component.dart';
import '../view_model/cubit/profile_cubit.dart';

class ProfileMainSalary extends StatelessWidget {
  const ProfileMainSalary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getSalriesProfile(context),
      child: BaseScaffold(
        currentNavIndex: 2, // Profile section
        backgroundColor: AppColors.backgroundColor,
        appBar: SecondaryAppBar(
          title: 'Salary History',
          showBackButton: true,
          notificationCount: DataHelper.unreadNotificationCount,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            var cubit = ProfileCubit.get(context);
            return SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => cubit.getSalriesProfile(context),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pagePaddingHorizontal,
                        vertical: AppSpacing.pagePaddingVertical,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              Text('Select Year', style: AppTypography.helperText()),
                              const SizedBox(width: 12),
                              Flexible(
                                child: FilterSelectField(
                                  label: '',
                                  value: cubit.selectedYear,
                                  options: cubit.availableYears,
                                  onChanged: (value) => cubit.changeSalaryYear(value, context),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sectionMargin),
                          // Past Salaries Section
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/images/money.svg',
                                width: 20,
                                height: 20,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.darkText, 
                                  BlendMode.srcIn,
                                ),
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
                          if(cubit.salary != null)
                          ...cubit.salary!.salaries.map((salary) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: MainSalariesComponent(
                                salary: salary,
                                viewMore: () => cubit.getSalryDetails(context, salary.id),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  if(state is ProfileLoading) const LoadingWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}