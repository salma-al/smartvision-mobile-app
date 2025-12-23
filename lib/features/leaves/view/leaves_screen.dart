import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/features/leaves/components/leave_history_tab.dart';
import 'package:smart_vision/features/leaves/components/leaves_request_tab.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../components/pill_tabs.dart';
import '../view_model/cubit/leaves_cubit.dart';

class LeavesScreen extends StatelessWidget {
  const LeavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeavesCubit()..filterLeaveHistory(context),
      child: BlocBuilder<LeavesCubit, LeavesState>(
        builder: (context, state) {
          var cubit = LeavesCubit.get(context);
          return BaseScaffold(
            currentNavIndex: 0, // Home section
            appBar: SecondaryAppBar(
              title: 'Leave Request',
              notificationCount: DataHelper.unreadNotificationCount,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => cubit.filterLeaveHistory(context),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.pagePaddingHorizontal,
                        vertical: AppSpacing.pagePaddingVertical,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tabs
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
                            LeavesRequestTab(
                              leavesTypes: cubit.leaveTypes, 
                              selectedLeave: cubit.selectedLeaveType, 
                              changeLeaveType: (type) => cubit.changeLeaveType(type), 
                              startDate: cubit.startDate, 
                              endDate: cubit.endDate, 
                              changeDate: (date, isStart) => cubit.changeDate(date, isStart), 
                              reasonController: cubit.reasonController,
                              attach: cubit.attach, 
                              pickFile: () => cubit.pickFile(), 
                              removeFile: () => cubit.removeFile(), 
                              submit: () => cubit.submitLeave(context),
                            )
                          else
                            LeaveHistoryTab(
                              types: cubit.leaveTypes, 
                              records: cubit.leaveRecords, 
                              filter: (from, to, type) => cubit.filterLeaveHistory(context, type, from, to),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if(state is LeavesLoadingState) const LoadingWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}