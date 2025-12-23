import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/helper/shared_functions.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../components/info_item.dart';
import '../components/time_log_item.dart';
import '../components/time_state_item.dart';
import '../view_model/cubit/sign_in_out_cubit.dart';

class SignInOutScreen extends StatelessWidget {
  const SignInOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime current = DateTime.now();
    return BlocProvider(
      create: (context) => SignInOutCubit()..getLastChecks(context),
      child: BlocBuilder<SignInOutCubit, SignInOutState>(
        builder: (context, state) {
          var cubit = SignInOutCubit.get(context);
          return BaseScaffold(
            currentNavIndex: 1,
            appBar: SecondaryAppBar(title: 'Check In', showBackButton: false, notificationCount: DataHelper.unreadNotificationCount),
            body: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => cubit.getLastChecks(context),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePaddingHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.lightText),
                            const SizedBox(width: 6),
                            Text('${getDayName(current.weekday)}, ${getFullMonthName(current.month)} ${current.day}, ${current.year}', style: AppTypography.helperText()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Company Info Cards
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
                            boxShadow: AppShadows.defaultShadow,
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: InfoItem(
                                  icon: 'assets/images/case.svg',
                                  iconColor: AppColors.red,
                                  iconBg: Color(0x14CB1933),
                                  label: 'Company',
                                  value: 'SVG',
                                ),
                              ),
                              Expanded(
                                child: InfoItem(
                                  icon: 'assets/images/clock_grey.svg',
                                  iconColor: AppColors.red,
                                  iconBg: const Color(0x14CB1933),
                                  label: 'Shift Hours',
                                  value: cubit.checkModel != null ? '${cubit.checkModel!.startTime} - ${cubit.checkModel!.endTime}' : '--- - ---',
                                ),
                              ),
                              const Expanded(
                                child: InfoItem(
                                  icon: 'assets/images/note.svg',
                                  iconColor: AppColors.red,
                                  iconBg: Color(0x14CB1933),
                                  label: 'Break Hours',
                                  value: '1 PM - 2 PM',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Check In/Out Section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
                            boxShadow: AppShadows.defaultShadow,
                          ),
                          child: Column(
                            children: [
                              // Icon and title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 20,
                                    color: AppColors.darkText,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    cubit.isCheckedIn ? 'Check In Time' : 'Tap to Check In',
                                    style: AppTypography.p16(),
                                  ),
                                ],
                              ),
                              // Time display
                              if (cubit.availableCheck && cubit.checkModel != null && cubit.checkModel!.records.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text(
                                  cubit.checkModel!.records.last.checkInTime,
                                  style: const TextStyle(
                                    color: Color(0xFF0A0A0A),
                                    fontFamily: 'DM Sans',
                                    fontSize: 36,
                                    fontWeight: FontWeight.w400,
                                    height: 40 / 36,
                                    letterSpacing: 5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              const SizedBox(height: 24),
                              // Check In/Out button
                              if(cubit.availableCheck && cubit.checkModel != null && !cubit.checkModel!.requiredImage)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: cubit.isCheckedIn ? 
                                    () => cubit.checkFunction(context, true) : 
                                    () => cubit.checkFunction(context, false),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: !cubit.isCheckedIn 
                                        ? const Color(0xFF991B1B)
                                        : const Color(0xFF065F46),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check_circle_outline, size: 20, color: AppColors.white),
                                      const SizedBox(width: 8),
                                      Text(
                                        cubit.isCheckedIn ? 'Check In' : 'Check Out',
                                        style: AppTypography.p16(color: AppColors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Check In/Out Photo Section
                        if(cubit.availableCheck)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
                            boxShadow: AppShadows.defaultShadow,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 18,
                                color: AppColors.darkText,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  cubit.isCheckedIn ? 'Take Check In Photo' : 'Take Check OUT Photo',
                                  style: AppTypography.p14(),
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () => cubit.pickImage(context),
                                borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(AppBorderRadius.radius8),
                                    border: Border.all(color: AppColors.dividerLight, width: 1),
                                  ),
                                  child: Text(
                                    'Capture',
                                    style: AppTypography.helperTextSmall(color: AppColors.darkText),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Today's Progress (always shown)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
                            boxShadow: AppShadows.defaultShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Today\'s Progress', style: AppTypography.p16()),
                              const SizedBox(height: 16),
                              // Progress label and percentage
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Work Progress', style: AppTypography.helperTextSmall()),
                                  Text('${cubit.formatDurationShort(cubit.getTotalWorked())}%', style: AppTypography.helperTextSmall()),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Progress bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: cubit.getTotalWorked().inMinutes / 540,
                                  minHeight: 8,
                                  backgroundColor: const Color(0xFFE5E7EB),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkText),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Time stats
                              Row(
                                children: [
                                  Expanded(
                                    child: TimeStateItem(
                                      label: 'Worked',
                                      value: (cubit.isCheckedIn || (cubit.checkModel != null && cubit.checkModel!.records.isNotEmpty))
                                          ? cubit.formatDurationShort(cubit.getTotalWorked()) : '--:--:--',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TimeStateItem(
                                      label: 'Remaining',
                                      value: (cubit.isCheckedIn || (cubit.checkModel != null && cubit.checkModel!.records.isNotEmpty))
                                          ? cubit.formatDurationShort(Duration(seconds: (32400 - cubit.getTotalWorked().inSeconds).clamp(0, 32400))) : '--:--:--',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(child: TimeStateItem(label: 'Total', value: '9:00:00')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Time Log (shown when checked in or has logs)
                        if (cubit.checkModel != null && cubit.checkModel!.records.isNotEmpty) ...[
                          for (int i = 0; i < cubit.checkModel!.records.length; i++) ...[
                            if (cubit.checkModel!.records[i].checkInTime != '---')
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
                                  boxShadow: AppShadows.defaultShadow,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Time Log', style: AppTypography.p16()),
                                    const SizedBox(height: 16),
                                    TimeLogItem(
                                      icon: SvgPicture.asset(
                                        'assets/images/check_green.svg',
                                        width: 18,
                                        height: 18,
                                        colorFilter: const ColorFilter.mode(AppColors.green, BlendMode.srcIn),
                                      ),
                                      iconColor: AppColors.green,
                                      label: 'Check In Time',
                                      time: cubit.formatFullTime(cubit.checkModel!.records[i].checkInTime),
                                    ),
                                    const SizedBox(height: 12),
                                    TimeLogItem(
                                      icon: SvgPicture.asset(
                                        'assets/images/X_red.svg',
                                        width: 18,
                                        height: 18,
                                        colorFilter: const ColorFilter.mode(AppColors.red, BlendMode.srcIn),
                                      ),
                                      iconColor: AppColors.red,
                                      label: 'Check Out Time',
                                      time: (cubit.checkModel!.records[i].checkOutTime != '---') ? 
                                       cubit.formatFullTime(cubit.checkModel!.records[i].checkOutTime) : '--:--',
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ],
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if(state is CheckInOutLoading) LoadingWidget(progress: cubit.uploadProgress),
              ],
            ),
          );
        },
      ),
    );
  }
}