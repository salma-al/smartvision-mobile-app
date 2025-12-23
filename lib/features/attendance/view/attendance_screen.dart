import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_vision/features/attendance/components/state_item.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/filter_select_field.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../../attendance/view_model/cubit/attendance_cubit.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceCubit()..getAttendaceStatistics(context),
      child: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          var cubit = AttendanceCubit.get(context);
          return BaseScaffold(
            currentNavIndex: 0, // Home section
            appBar: SecondaryAppBar(
              title: 'Attendance Report',
              notificationCount: DataHelper.unreadNotificationCount,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => cubit.getAttendaceStatistics(context),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pagePaddingHorizontal,
                        vertical: AppSpacing.pagePaddingVertical,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined, color: AppColors.darkText, size: 18),
                              const SizedBox(width: 8),
                              Text('Period', style: AppTypography.helperText()),
                              const SizedBox(width: 12),
                              Flexible(
                                child: FilterSelectField(
                                  label: '',
                                  value: cubit.monthNames[cubit.selectedMonth - 1],
                                  options: cubit.monthNames,
                                  onChanged: (month) {
                                    cubit.changeMonth(month);
                                    cubit.getAttendaceStatistics(context);
                                  },
                                  leadingSvgAsset: null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              SvgPicture.asset(
                                'assets/images/filter.svg',
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.darkText,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('Type', style: AppTypography.helperText()),
                              const SizedBox(width: 12),
                              Flexible(
                                child: FilterSelectField(
                                  label: '',
                                  value: cubit.selectedType,
                                  options: const ['All', 'Present', 'Absent', 'Leave'],
                                  onChanged: (v) {
                                    cubit.changeType(v);
                                    cubit.getAttendaceStatistics(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sectionMargin),
                          if(cubit.attendance != null) ...[
                            Row(
                              children: [
                                StateItem(
                                  bg: const Color(0xFFDCFCE7), color: AppColors.green, label: 'Present',
                                  iconWidget: SvgPicture.asset(
                                    'assets/images/arrow_up.svg',
                                    width: 28,
                                    height: 24.7,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.green,
                                      BlendMode.srcIn,
                                    ),
                                  ), 
                                  trend: cubit.attendance!.present.toString(),
                                ),
                                const SizedBox(width: 12),
                                StateItem(
                                  bg: const Color(0xFFFFE2E2), color: AppColors.red, label: 'Absent',
                                  iconWidget: SvgPicture.asset(
                                    'assets/images/arrow_down.svg',
                                    width: 28,
                                    height: 24.7,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.red,
                                      BlendMode.srcIn,
                                    ),
                                  ), 
                                  trend: cubit.attendance!.absent.toString(),
                                ),
                                const SizedBox(width: 12),
                                StateItem(
                                  bg: const Color(0xFFDBEAFE), color: AppColors.blue, label: 'Leaves',
                                  iconWidget: SvgPicture.asset(
                                    'assets/images/palm_tree.svg',
                                    width: 26,
                                    height: 24.7,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.blue,
                                      BlendMode.srcIn,
                                    ),
                                  ), 
                                  trend: cubit.attendance!.leave.toString(),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sectionMargin),
                            Text('Daily Attendance', style: AppTypography.h3()),
                            const SizedBox(height: AppSpacing.sameSectionMargin),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(AppBorderRadius.radius14),
                                boxShadow: AppShadows.defaultShadow,
                              ),
                              child: Column(
                                children: [
                                  for (int i = 0; i < cubit.attendance!.dailyData.length; i++)
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        border: i == cubit.attendance!.dailyData.length - 1
                                          ? null
                                          : const Border(bottom: BorderSide(color: AppColors.dividerLight, width: 1.173)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Row 1: date tile, badges, total hours
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(6),
                                                width: 49.0,
                                                height: 49.0,
                                                decoration: BoxDecoration(
                                                  color: cubit.statusBgColor(cubit.attendance!.dailyData[i].status),
                                                  borderRadius: BorderRadius.circular(AppBorderRadius.radius12),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('${cubit.attendance!.dailyData[i].dayNum}', style: AppTypography.p14(color: AppColors.darkText)),
                                                    Text(cubit.attendance!.dailyData[i].dayName.substring(0, 3), style: AppTypography.p12(color: AppColors.lightText)),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Wrap(
                                                  spacing: 8,
                                                  runSpacing: 6,
                                                  children: [
                                                    AppBadge(
                                                      label: cubit.attendance!.dailyData[i].status,
                                                      color: cubit.statusColor(cubit.attendance!.dailyData[i].status),
                                                      variant: BadgeVariant.filled,
                                                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                                      backgroundColor: cubit.statusBgColor(cubit.attendance!.dailyData[i].status),
                                                    ),
                                                    if (cubit.attendance!.dailyData[i].reason != null) 
                                                      AppBadge(
                                                        label: cubit.attendance!.dailyData[i].reason ?? '', 
                                                        color: cubit.reasonColor(cubit.attendance!.dailyData[i].reason ?? ''),
                                                        variant: BadgeVariant.outline,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              if (cubit.attendance!.dailyData[i].hasChecked)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Text(cubit.attendance!.dailyData[i].totalHours ?? '', style: AppTypography.p14()),
                                                    Text('Total Hours', style: AppTypography.helperTextSmall()),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          // Row 2: in/out or message
                                          if (!cubit.attendance!.dailyData[i].hasChecked)
                                            Text('No check-in recorded', style: AppTypography.helperText(), textAlign: TextAlign.left)
                                          else
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time, size: 16, color: AppColors.helperText),
                                                const SizedBox(width: 6),
                                                Text('In:', style: AppTypography.helperText()),
                                                const SizedBox(width: 4),
                                                Text(cubit.attendance!.dailyData[i].inTime ?? '', style: AppTypography.helperText()),
                                                const SizedBox(width: 16),
                                                const Icon(Icons.access_time, size: 16, color: AppColors.helperText),
                                                const SizedBox(width: 6),
                                                Text('Out:', style: AppTypography.helperText()),
                                                const SizedBox(width: 4),
                                                Text(cubit.attendance!.dailyData[i].outTime ?? '', style: AppTypography.helperText()),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if(state is AttendanceLoading) const LoadingWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}