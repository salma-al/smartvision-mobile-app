import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/features/reports/components/count_component.dart';

import '../components/request_card_component.dart';
import '../view_model/cubit/reports_cubit.dart';
import '../model/requests_model.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/media_query_values.dart';
import '../../../core/widgets/custom_drop_down_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/loading_widget.dart';

class ReportRequests extends StatelessWidget {
  const ReportRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Requests Report', style: TextStyle(color: AppColors.mainColor)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Image.asset('assets/images/home_logo.png', width: 40, height: 40),
          const SizedBox(width: 15),
        ],
        backgroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => ReportsCubit(),
        child: BlocBuilder<ReportsCubit, ReportsState>(
          builder: (context, state) {
            var cubit = ReportsCubit.get(context);
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => cubit.getRequests(context),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  text: cubit.fromDate != null ? cubit.fromDate! : 'From Date',
                                  onTap: () => cubit.selectDate(context, true),
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  textColor: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: PrimaryButton(
                                  text: cubit.toDate != null ? cubit.toDate! : 'To Date',
                                  onTap: () => cubit.selectDate(context, false),
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  textColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          CustomDropdownFormField<String>(
                            hintText: 'Type',
                            value: cubit.currRequestFilter,
                            items: const [
                              DropdownMenuItem( value: 'leave', child: Text('Leave Requests')),
                              DropdownMenuItem( value: 'shift', child: Text('Shift Requests')),
                            ],
                            onChanged: (value) => cubit.changeRequestType(value),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                            child: PrimaryButton(
                              text: 'Apply filters',
                              onTap: () => cubit.getRequests(context),
                              color: AppColors.mainColor.withValues(alpha: 0.8),
                              textColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (cubit.currRequestFilter != null)
                          CountComponent(
                            counts: const ['Requested', 'Approved', 'Rejected', 'Cancelled', 'Manager Approved'], 
                            getTextColor: (s) => cubit.getRequestsStatusColor(s), 
                            getTextCount: (s) => cubit.getRequestsCount(s),
                            collapse: () => cubit.collapseCounts(),
                            collapsed: cubit.isCollapsed,
                          ),
                          const SizedBox(height: 16),
                          cubit.shiftRequests.isEmpty && cubit.leaveRequests.isEmpty ? 
                            Center(
                              child: Text(
                                'No requests data for selected criteria.',
                                style: TextStyle(fontSize: 16, color: HexColor('#497B7B')),
                              ),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cubit.typeSwitch == 1 ? cubit.leaveRequests.length : cubit.shiftRequests.length,
                              itemBuilder: (context, index) {
                                if(cubit.typeSwitch == 1) {
                                  final LeaveRequestsModel request = cubit.leaveRequests[index];
                                  return RequestCardComponent(
                                    type: request.type, 
                                    status: request.status, 
                                    fromDate: request.fromDate, 
                                    toDate: request.toDate, 
                                    reason: request.description,
                                    statusColor: cubit.getRequestsStatusColor(request.status),
                                  );
                                }else if(cubit.typeSwitch == 2) {
                                  final ShiftRequestsModel request = cubit.shiftRequests[index];
                                  return RequestCardComponent(
                                    type: request.type, 
                                    status: request.status, 
                                    fromDate: request.fromDate, 
                                    toDate: request.toDate, 
                                    reason: '', 
                                    statusColor: cubit.getRequestsStatusColor(request.status),
                                  );
                                }else {
                                  return Container();
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if(cubit.reportLoading) const LoadingWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}