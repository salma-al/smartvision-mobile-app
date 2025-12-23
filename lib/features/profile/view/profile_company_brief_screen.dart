// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../view_model/cubit/profile_cubit.dart';

class CompanyProfileScreen extends StatelessWidget {
  const CompanyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getCompanyProfile(context),
      child: BaseScaffold(
        currentNavIndex: 2, // Profile section
        appBar: SecondaryAppBar(
          title: 'Company Overview',
          showBackButton: true,
          notificationCount: DataHelper.unreadNotificationCount,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => context.read<ProfileCubit>().getCompanyProfile(context),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                      child: Column(
                        children: [
                          // About Section
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
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/building.svg',
                                      width: 24,
                                      height: 24,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.darkText,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'About ${state is CompanyLoaded ? state.info.companyName : 'Company'}',
                                      style: AppTypography.body16(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Html(
                                  data: state is CompanyLoaded ? state.info.brief : '',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Contact Information Section
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
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/phone.svg',
                                      width: 24,
                                      height: 24,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.darkText,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Contact Information',
                                      style: AppTypography.body16(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
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
                                        state is CompanyLoaded ? state.info.website : '',
                                        style: AppTypography.p16(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
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
                                        state is CompanyLoaded ? state.info.phone : '',
                                        style: AppTypography.p16(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
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
                                        state is CompanyLoaded ? state.info.email : '',
                                        style: AppTypography.p16(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
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