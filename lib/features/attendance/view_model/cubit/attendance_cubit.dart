import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import 'package:smart_vision/features/attendance/model/attendace_statistics_model.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  static AttendanceCubit get(context) => BlocProvider.of(context);

  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  int selectedDay = DateTime.now().day;
  List<int> availableYears = List.generate(5, (index) => DateTime.now().year - index);
  List<int>? days;
  List<String> monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  bool attendanceLoading = false;
  AttendanceStatisticsModel dailyAttendance = AttendanceStatisticsModel(
    present: 0, abscent: 0, leave: 0, halfDay: 0, fromHome: 0, late: 0, early: 0, onTime: 0, totalHours: '', checkIn: '', checkOut: '');

  initializeDays() {
    days = getDaysInMonth();
    emit(DaysGenerated());
  }
  List<int> getDaysInMonth() {
    int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }
  changeDay(int day) {
    selectedDay = day;
    emit(DayChanged());
  }
  changeMonth(int month) {
    selectedMonth = month;
    initializeDays();
  }
  getAttendaceStatistics(context) async{
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId!,
      'year': selectedYear.toString(),
      'month': selectedMonth.toString(),
    };
    attendanceLoading = true;
    emit(AttendanceLoading());
    try{
      final data = await HTTPHelper.httpPost(EndPoints.getAttendance, body, context);
      attendanceLoading = false;
      if(data['message']['status'] == 'success'){
        dailyAttendance.present = data['message']['data']['present'];
        dailyAttendance.abscent = data['message']['data']['absent'];
        dailyAttendance.leave = data['message']['data']['on_leave'];
        dailyAttendance.halfDay = data['message']['data']['half_day'];
        dailyAttendance.fromHome = data['message']['data']['work_from_home'];
        dailyAttendance.totalHours = data['message']['data']['total_working_hours'];
        emit(AttendanceLoaded());
      }else {
        ToastWidget().showToast('Something went wrong', context);
        emit(AttendanceError());
      }
    }catch(e) {
      ToastWidget().showToast('Something went wrong', context);
      attendanceLoading = false;
      emit(AttendanceError());
    }
    await getCheckedData(context);
  }
  getCheckedData(context) async{
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId!,
      'year': selectedYear.toString(),
      'month': selectedMonth.toString(),
      'day': selectedDay.toString(),
    };
    attendanceLoading = true;
    emit(AttendanceLoading());
    try{
      final data = await HTTPHelper.httpPost(EndPoints.getAttendance, body, context);
      attendanceLoading = false;
      if(data['message']['status'] == 'success'){
        String? checkIn = data['message']['data']['first_check_in'];
        String? checkOut = data['message']['data']['last_check_out'];
        String inTime = checkIn == null ? '---' : '${DateTime.parse(checkIn).hour.toString().padLeft(2, '0')}:${DateTime.parse(checkIn).minute.toString().padLeft(2, '0')}' ;
        String outTime = checkOut == null ? '---' : '${DateTime.parse(checkOut).hour.toString().padLeft(2, '0')}:${DateTime.parse(checkOut).minute.toString().padLeft(2, '0')}';
        dailyAttendance.checkIn = inTime;
        dailyAttendance.checkOut = inTime != outTime ? outTime : '---';
        dailyAttendance.late = data['message']['data']['lateness_stats']['lateness_stats']['late'];
        dailyAttendance.early = data['message']['data']['lateness_stats']['lateness_stats']['early'];
        dailyAttendance.onTime = data['message']['data']['lateness_stats']['lateness_stats']['on_time'];
        emit(AttendanceLoaded());
      }else {
        ToastWidget().showToast('Something went wrong', context);
        emit(AttendanceError());
      }
    }catch(e) {
      ToastWidget().showToast('Something went wrong', context);
      attendanceLoading = false;
      emit(AttendanceError());
    }
  }
}
