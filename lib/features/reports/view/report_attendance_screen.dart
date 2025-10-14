import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/utils/colors.dart';
import 'package:smart_vision/core/widgets/charts_widgets.dart';
import 'package:smart_vision/core/widgets/custom_drop_down_field.dart';
import 'package:smart_vision/core/widgets/loading_widget.dart';
import 'package:smart_vision/core/widgets/primary_button.dart';
import 'package:smart_vision/features/reports/view_model/cubit/reports_cubit.dart';

import '../components/attendance_report_component.dart';

class ReportAttendance extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ReportAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportsCubit(),
      child: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          var cubit = ReportsCubit.get(context);

          _scrollController.addListener(() {
            if (_scrollController.offset > 200 && !_scrollController.position.outOfRange) {
              BlocProvider.of<ReportsCubit>(context).updateScroll(true);
            } else {
              BlocProvider.of<ReportsCubit>(context).updateScroll(false);
            }
          });
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text('Attendace Report',
                  style: TextStyle(color: AppColors.mainColor)),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(fontSize: 16, color: AppColors.darkColor, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: cubit.fromDate != null
                                  ? cubit.fromDate!
                                  : 'From Date',
                              onTap: () => cubit.selectDate(context, true),
                              color: Colors.grey.withValues(alpha: 0.2),
                              textColor: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: PrimaryButton(
                              text: cubit.toDate != null
                                  ? cubit.toDate!
                                  : 'To Date',
                              onTap: () => cubit.selectDate(context, false),
                              color: Colors.grey.withValues(alpha: 0.2),
                              textColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomDropdownFormField(
                        hintText: 'Type',
                        value: cubit.currAttendanceFilter,
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(value: 'Present', child: Text('Present')),
                          DropdownMenuItem(value: 'On Leave', child: Text('On Leave')),
                          DropdownMenuItem(value: 'Absent', child: Text('Absent')),
                          DropdownMenuItem(value: 'Work From Home', child: Text('Work From Home')),
                        ],
                        onChanged: (value) => cubit.changeAttendanceType(value),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: PrimaryButton(
                          text: 'Apply filters',
                          onTap: () => cubit.getAttendance(context),
                          color: AppColors.mainColor.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (cubit.currAttendanceFilter == 'All')
                        Center(
                          child: PieCharCenterTitletWidget(
                            labels: const ['Present', 'Work From Home', 'Absent', 'On Leave'],
                            values: [cubit.present, cubit.workFromHome, cubit.absent, cubit.onLeave],
                            colors: [
                              cubit.getStatusColor('Present'),
                              cubit.getStatusColor('Work\nFrom Home'),
                              cubit.getStatusColor('Absent'),
                              cubit.getStatusColor('On Leave')
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      cubit.attendance.isEmpty
                        ? Center(
                            child: Text(
                              'No requests data for selected criteria.',
                              style: TextStyle(fontSize: 16, color: HexColor('#497B7B')),
                            ),
                          )
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cubit.attendance.length,
                          itemBuilder: (context, index) {
                            final attendance = cubit.attendance[index];
                            final bool isFirst = index == 0;
                            final bool isLast = index == cubit.attendance.length - 1;
                            return AttendanceReportComponent(
                              isFirst: isFirst,
                              isLast: isLast,
                              type: attendance.status,
                              date: attendance.date,
                              status: attendance.status == 'Work From Home' ? 'WFH' : attendance.status,
                              color: cubit.getStatusColor(attendance.status),
                            );
                          },
                        ),
                    ],
                  ),
                ),
                cubit.scrolled
                  ? Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        backgroundColor: Colors.grey.shade200,
                        child: Icon(Icons.arrow_upward_rounded, color: AppColors.mainColor,),
                      ),
                    )
                  : const SizedBox.shrink(),
                if (cubit.reportLoading) const LoadingWidget()
              ],
            ),
          );
        },
      ),
    );
  }
}