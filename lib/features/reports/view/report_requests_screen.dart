import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/core/utils/media_query_values.dart';
import 'package:smart_vision/core/widgets/custom_drop_down_field.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/core/widgets/primary_button.dart';
import 'package:smart_vision/features/reports/components/request_card_component.dart';
import 'package:smart_vision/features/reports/view_model/cubit/reports_cubit.dart';

import '../components/request_counter_component.dart';

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: cubit.fromDate != null ? cubit.fromDate! : 'From Date',
                              onTap: () => cubit.selectDate(context, true),
                              color: Colors.grey.withOpacity(0.2),
                              textColor: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: PrimaryButton(
                              text: cubit.toDate != null ? cubit.toDate! : 'To Date',
                              onTap: () => cubit.selectDate(context, false),
                              color: Colors.grey.withOpacity(0.2),
                              textColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomDropdownFormField(
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
                          color: AppColors.mainColor.withOpacity(0.8),
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (cubit.currRequestFilter != null && cubit.openCount != 0 || cubit.draftCount != 0 || cubit.approvedCount != 0 || cubit.rejectedCount != 0 || cubit.cancelledCount != 0)
                      SizedBox(
                        width: context.width,
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          children: cubit.typeSwitch == 1 ? ['Open', 'Approved', 'Rejected', 'Cancelled'].map((status) => 
                            RequestCounterComponent(
                              status: status, 
                              count: status == 'Open' ? cubit.openCount : status == 'Approved' ? cubit.approvedCount : status == 'Rejected' ? cubit.rejectedCount : cubit.cancelledCount, 
                              color: cubit.getRequestsStatusColor(status),
                            )).toList()
                            : cubit.typeSwitch == 2 ? ['Draft', 'Approved', 'Rejected'].map((status) => 
                            RequestCounterComponent(
                              status: status,
                              count: status == 'Draft' ? cubit.draftCount : status == 'Approved' ? cubit.approvedCount : cubit.rejectedCount,
                              color: cubit.getRequestsStatusColor(status),
                            )).toList()
                            : [],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: cubit.shiftRequests.isEmpty && cubit.leaveRequests.isEmpty ? 
                          Center(
                            child: Text(
                              'No requests data for selected criteria.',
                              style: TextStyle(
                                  fontSize: 16, color: HexColor('#497B7B')),
                            ),
                          )
                          : RefreshIndicator(
                            onRefresh: () => cubit.getRequests(context),
                            child: ListView.builder(
                              itemCount: cubit.typeSwitch == 1 ? cubit.leaveRequests.length : cubit.shiftRequests.length,
                              itemBuilder: (context, index) {
                                // Determine whether the current item is the first or last
                                final bool isFirst = index == 0;
                                final bool isLast = cubit.typeSwitch == 1 ? index == cubit.leaveRequests.length - 1 : index == cubit.shiftRequests.length - 1;
                                BorderRadiusGeometry? borderRadius = BorderRadius.only(
                                  topLeft: Radius.circular(isFirst ? 12 : 0), topRight: Radius.circular(isFirst ? 12 : 0),
                                  bottomLeft: Radius.circular(isLast ? 12 : 0), bottomRight: Radius.circular(isLast ? 12 : 0),
                                );
                                BorderRadiusGeometry? statusBorderRadius = BorderRadius.only(
                                  topRight: Radius.circular(isFirst ? 12 : 0), bottomRight: Radius.circular(isLast ? 12 : 0),
                                );

                                if(cubit.typeSwitch == 1) {
                                  final request = cubit.leaveRequests[index];
                                  return RequestCardComponent(
                                    type: request.type, 
                                    status: request.status, 
                                    fromDate: request.fromDate, 
                                    toDate: request.toDate, 
                                    reason: request.description, 
                                    statusColor: cubit.getRequestsStatusColor(request.status),
                                    borderRadius: borderRadius,
                                    statusBorderRadius: statusBorderRadius,
                                  );
                                }else if(cubit.typeSwitch == 2) {
                                  final request = cubit.shiftRequests[index];
                                  return RequestCardComponent(
                                    type: request.type, 
                                    status: request.status, 
                                    fromDate: request.fromDate, 
                                    toDate: request.toDate, 
                                    reason: '', 
                                    statusColor: cubit.getRequestsStatusColor(request.status),
                                    borderRadius: borderRadius,
                                    statusBorderRadius: statusBorderRadius,
                                  );
                                }else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
                if(cubit.reportLoading)
                const LoadingWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}
