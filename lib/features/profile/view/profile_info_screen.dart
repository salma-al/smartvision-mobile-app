// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../components/personal_department_component.dart';
import '../components/personal_info_component.dart';
import '../view_model/cubit/profile_cubit.dart';

class ProfileInfoScreen extends StatelessWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final instance = DataHelper.instance;
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileInfo(context),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          bool isLoaded = state is PersonalInfoLoaded;
          return BaseScaffold(
            currentNavIndex: 2, // Profile section
            appBar: SecondaryAppBar(
              title: 'Personal Information',
              showBackButton: true,
              notificationCount: DataHelper.unreadNotificationCount,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => context.read<ProfileCubit>().getProfileInfo(context),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 20.0,
                        ),
                        child: Column(
                          children: [
                            Container(
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF39383C),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: (instance.img != null && instance.img!.isNotEmpty) ? 
                                            Image.network(
                                              instance.img!, 
                                              fit: BoxFit.fill,
                                              errorBuilder: (context, error, stackTrace) => Text(
                                                (instance.name ?? '').substring(0, 2),
                                                style: AppTypography.h3(color: AppColors.white),
                                              ),
                                            ) :
                                            Text(
                                              (instance.name ?? '').substring(0, 2),
                                              style: AppTypography.h3(color: AppColors.white),
                                            ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              instance.name ?? '',
                                              style: AppTypography.p16(),
                                            ),
                                            const SizedBox(height: 1.5),
                                            Text(
                                              instance.userId ?? '',
                                              style: AppTypography.helperText(),
                                            ),
                                            const SizedBox(height: 4),
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
                                                isLoaded ? state.info.isActive : '-',
                                                style: AppTypography.p12(color: AppColors.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  InfoColumn(
                                    label: 'Work Email',
                                    value: instance.email ?? '',
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: InfoColumn(
                                          label: 'Default Shift',
                                          value: isLoaded ? state.info.shift : '-',
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: InfoColumn(
                                          label: 'Break Hours',
                                          value: isLoaded ? state.info.breakHours : '-',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: InfoColumn(
                                          label: 'Join Date',
                                          value: isLoaded ? state.info.joinDate : '-',
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: InfoColumn(
                                          label: 'Employment Type',
                                          value: isLoaded ? state.info.employmentType : '-',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            PersonalDepartmentComponent(
                              title: isLoaded ? state.info.jobTitle : '-',
                              dep: isLoaded ? state.info.dep : '-',
                              manager: isLoaded ? state.info.managerName : '-',
                              manTitle: isLoaded ? state.info.managerTitle : '-',
                              manMail: isLoaded ? state.info.managetMail : '-',
                              location: isLoaded ? state.info.workLocation : '-',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if(state is ProfileLoading) const LoadingWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}