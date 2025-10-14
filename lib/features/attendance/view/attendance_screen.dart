import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_vision/core/utils/colors.dart';

import '../../../core/utils/media_query_values.dart';
import '../../../core/widgets/charts_widgets.dart';
import '../../../core/widgets/custom_drop_down_field.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/primary_button.dart';
import '../../attendance/view_model/cubit/attendance_cubit.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceCubit()..initializeDays()..getAttendaceStatistics(context),
      child: BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          var cubit = AttendanceCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text('Attendance', style: TextStyle(color: AppColors.mainColor)),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.mainColor),
                  onPressed: () => Navigator.pop(context)),
              backgroundColor: Colors.white,
              actions: [
                Image.asset('assets/images/home_logo.png', width: 40, height: 40),
                const SizedBox(width: 15),
              ],
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: RefreshIndicator(
                    onRefresh: () => cubit.getAttendaceStatistics(context),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: context.width * 0.3,
                                child: CustomDropdownFormField(
                                  raduis: 35,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  hintText: 'Months',
                                  items: cubit.monthNames.map((e) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: cubit.monthNames.indexOf(e) + 1,
                                    child: Text(e, textAlign: TextAlign.center)),
                                  ).toList(),
                                  value: cubit.selectedMonth,
                                  onChanged: (val) => cubit.changeMonth(val!),
                                ),
                              ),
                              SizedBox(
                                width: context.width * 0.3,
                                child: CustomDropdownFormField(
                                  raduis: 35,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  hintText: 'Years',
                                  items: cubit.availableYears.map((e) => DropdownMenuItem(
                                    alignment: AlignmentDirectional.center,
                                    value: e,
                                    child: Text(e.toString(), textAlign: TextAlign.center),),
                                  ).toList(),
                                  value: cubit.selectedYear,
                                  onChanged: (val) => cubit.selectedYear = val!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          width: context.width,
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: cubit.days!.map((day) {
                              return GestureDetector(
                                onTap: () => cubit.changeDay(day),
                                child: Container(
                                  width: 40,
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: cubit.selectedDay == day
                                        ? const Color.fromARGB(255, 174, 12, 0).withValues(alpha: 0.7)
                                        : AppColors.mainColor.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.2),
                          child: PrimaryButton(
                            text: 'Show Data',
                            color: Colors.grey,
                            onTap: () => cubit.getAttendaceStatistics(context),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text('Check In: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainColor)),
                                  Text(cubit.dailyAttendance.checkIn),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Check Out: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainColor)),
                                  Text(cubit.dailyAttendance.checkOut),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Month Total Working Hours: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mainColor)),
                              Text(cubit.dailyAttendance.totalHours),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          // color: HexColor('#FFF8DB').withValues(alpha: 0.5),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PieChartWidget(
                                values: [cubit.dailyAttendance.early, cubit.dailyAttendance.onTime, cubit.dailyAttendance.late], // Early, On-Time, Late counts
                                labels: const ['Early', 'On-Time', 'Late'],
                                title: 'Arrival',
                              ),
                              PieChartWidget(
                                values: [cubit.dailyAttendance.present, cubit.dailyAttendance.leave, cubit.dailyAttendance.abscent], // Attendance, Vacation, Absences
                                labels: const ['Attendance', 'Leaves', 'Absences'],
                                title: 'Monthly Stats',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (cubit.attendanceLoading)
                const LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}