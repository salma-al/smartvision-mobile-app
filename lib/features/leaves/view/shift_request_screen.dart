import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/helper/data_helper.dart';
import '../../../core/widgets/base_scaffold.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/secondary_app_bar.dart';
import '../components/pill_tabs.dart';
import '../components/shift_request_tab.dart';
import '../components/shift_history_tab.dart';
import '../view_model/cubit/leaves_cubit.dart';

class ShiftRequestScreen extends StatelessWidget {
  const ShiftRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeavesCubit()..filterShiftHistory(context),
      child: BaseScaffold(
        currentNavIndex: 0,
        appBar: SecondaryAppBar(
          title: 'Shift Request',
          notificationCount: DataHelper.unreadNotificationCount,
        ),
        body: SafeArea(
          child: BlocBuilder<LeavesCubit, LeavesState>(
            builder: (ctx, state) {
              var cubit = LeavesCubit.get(ctx);
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => cubit.filterShiftHistory(context),
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
                            ShiftRequestTab(
                              selectedShift: cubit.selectedShift,
                              changeShift: (shift) => cubit.changeShift(shift),
                              startDate: cubit.startDate,
                              selectDate: (date) => cubit.changeDate(date, true),
                              excuseTime: cubit.excuseTime,
                              excuseTyoe: cubit.excuseType,
                              changeExcuseTime: (time) => cubit.changeExcuseTime(time),
                              changeExcuseType: (type) => cubit.changeExcuseType(type),
                              excuseTimes: cubit.excuseTimes,
                              reasonController: cubit.reasonController,
                              submitShift: () => cubit.submitShift(ctx),
                            )
                          else
                            ShiftHistoryTab(
                              filter: (from, to, type) => cubit.filterShiftHistory(ctx, type, from, to),
                              records: cubit.shiftRecords,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if(state is LeavesLoadingState) const LoadingWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}