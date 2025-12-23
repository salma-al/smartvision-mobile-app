import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../components/pill_tabs.dart';
import '../components/overtime_history_tab.dart';
import '../components/overtime_request_tab.dart';
import '../view_model/cubit/leaves_cubit.dart';

class OvertimeRequestScreen extends StatelessWidget {
  const OvertimeRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeavesCubit()..filterOvertimeHistory(context),
      child: BaseScaffold(
        currentNavIndex: 0, // Home section
        appBar: SecondaryAppBar(
          title: 'Overtime Request',
          notificationCount: DataHelper.unreadNotificationCount,
        ),
        body: BlocBuilder<LeavesCubit, LeavesState>(
          builder: (context, state) {
            var cubit = LeavesCubit.get(context);
            return SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => cubit.filterOvertimeHistory(context),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PillTabs(
                                index: cubit.tabIndex,
                                tabs: const ['Request', 'History'],
                                onChanged: (i) => cubit.changeTab(i),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sectionMargin),
                          if (cubit.tabIndex == 0)
                            OvertimeRequestTab(
                              date: cubit.startDate,
                              changeDate: (date) => cubit.changeDate(date, true),
                              startTime: cubit.overtimeStartTime,
                              endTime: cubit.overtimeEndTime,
                              changeTime: (time, isStart) => cubit.changeOvertimeTime(time, isStart),
                              reasonController: cubit.reasonController,
                              submit: () => cubit.submitOvertime(context) ,
                            )
                          else
                            OvertimeHistoryTab(
                              records: cubit.overtimeRecords,
                              filter: (from, to, status) => cubit.filterOvertimeHistory(context, status, from, to),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if(state is LeavesLoadingState) const LoadingWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}