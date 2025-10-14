import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../components/count_component.dart';
import '../view_model/cubit/reports_cubit.dart';
import '../../../core/utils/colors.dart';
import '../../../core/utils/media_query_values.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/primary_button.dart';

class ReportOvertimeScreen extends StatelessWidget {
  const ReportOvertimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Overtime Report', style: TextStyle(color: AppColors.mainColor)),
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
                  onRefresh: () => cubit.getOverTimes(context),
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                            child: PrimaryButton(
                              text: 'Apply filters',
                              onTap: () => cubit.getOverTimes(context),
                              color: AppColors.mainColor.withValues(alpha: 0.8),
                              textColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (cubit.overtimeList.isNotEmpty)
                          CountComponent(
                            counts: const ['Requested', 'Manager Approved', 'Approved', 'Rejected', 'Cancelled'], 
                            getTextColor: (s) => cubit.getRequestsStatusColor(s), 
                            getTextCount: (s) => cubit.overtimeList.where((element) => element.status == s).length, 
                            collapse: () => cubit.collapseCounts(), 
                            collapsed: cubit.isCollapsed,
                          ),
                          const SizedBox(height: 16),
                          cubit.overtimeList.isEmpty ? 
                            Center(
                              child: Text(
                                'No requests data for selected criteria.',
                                style: TextStyle(fontSize: 16, color: HexColor('#497B7B')),
                              ),
                            )
                            : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cubit.overtimeList.length,
                              itemBuilder: (context, index) {
                                final overTime = cubit.overtimeList[index];
                                                      
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      // Main Details Column
                                      Padding(
                                        padding: const EdgeInsets.only(top: 24, left: 18, bottom: 12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                text: 'Date: ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.mainColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: overTime.date,
                                                    style: TextStyle(color: AppColors.darkColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            // From and To times in a single row
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: 'From: ',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors.mainColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: overTime.startTime,
                                                          style: TextStyle(color: AppColors.darkColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: 'To: ',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColors.mainColor,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: overTime.endTime,
                                                          style: TextStyle(color: AppColors.darkColor),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Reason: ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.mainColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: overTime.reason,
                                                    style: TextStyle(color: AppColors.darkColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Status Container
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                          color: cubit.getRequestsStatusColor(overTime.status),
                                        ),
                                        child: Text(overTime.status, style: const TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
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