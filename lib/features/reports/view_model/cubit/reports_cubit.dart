import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import 'package:smart_vision/features/reports/model/attendance_model.dart';
import 'package:smart_vision/features/reports/model/requests_model.dart';

import '../../model/overtime_model.dart';

part 'rreports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());

  static ReportsCubit get(context) => BlocProvider.of(context);
  
  String? currRequestFilter;
  String? currAttendanceFilter;
  String? fromDate;
  String? toDate;
  List<LeaveRequestsModel> leaveRequests = [];
  List<ShiftRequestsModel> shiftRequests = [];
  List<AttendanceModel> attendance = [];
  bool reportLoading = false;
  int openCount = 0;
  int draftCount = 0;
  int approvedCount = 0;
  int rejectedCount = 0;
  int cancelledCount = 0;
  int typeSwitch = 0;
  int present = 0;
  int onLeave = 0;
  int absent = 0;
  int workFromHome = 0;
  bool scrolled = false;
  List<OvertimeModel> overtimeList = [];

  updateScroll(bool isScrolled) {
    scrolled = isScrolled;
    emit(ReportScrolled());
  }
  selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2020);
    DateTime lastDate = DateTime(2030);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      if (isFromDate) {
        fromDate = '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
      } else {
        toDate = '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
      }
      emit(DateChanged());
    }
  }
  changeRequestType(String? type) {
    currRequestFilter = type;
    emit(ChangeRequestType());
  }
  changeAttendanceType(String? type) {
    currAttendanceFilter = type;
    emit(ChangeRequestType());
  }
  Color getStatusColor(String status) {
    switch (status) {
      case 'On Leave':
        return Colors.orange.withOpacity(0.7);
      case 'Work\nFrom Home':
      case 'Work From Home':
        return Colors.grey.withOpacity(0.7);
      case 'Absent':
        return Colors.red.withOpacity(0.7);
      case 'Present':
        return Colors.green.withOpacity(0.7);
      default:
        return Colors.transparent;
    }
  }
  Color getRequestsStatusColor(String status) {
    switch (status) {
      case 'Open':
      case 'Draft':
        return HexColor('#00b0ed');
      case 'Approved':
        return HexColor('#63ea73');
      case 'Rejected':
        return HexColor('#ff0000');
      case 'Cancelled':
        return HexColor('#db8200');
      default:
        return Colors.transparent;
    }
  }
  getRequests(context) async{
    if(currRequestFilter == null) {
      ToastWidget().showToast('Please select a filter', context);
      return;
    }
    final instance = DataHelper.instance;
    final body = {
      'employee_id': '${instance.userId}',
      'data_type': currRequestFilter,
    };
    if(fromDate != null && toDate != null) {
      body['from_date'] = fromDate;
      body['to_date'] = toDate;
    }
    reportLoading = true;
    emit(ReportLoading());
    try {
      final response = await HTTPHelper.httpPost(EndPoints.getRequestsReport, body, context);
      reportLoading = false;
      if(response['message']['status'] == 'success') {
        leaveRequests = [];
        shiftRequests = [];
        if(currRequestFilter == 'leave') {
          for(var ss in response['message']['data']) {
            if(ss['status'] != null) {
              leaveRequests.add(LeaveRequestsModel.fromJson(ss));
            }
          }
          openCount = leaveRequests.where((element) => element.status == 'Open').toList().length;
          approvedCount = leaveRequests.where((element) => element.status == 'Approved').toList().length;
          rejectedCount = leaveRequests.where((element) => element.status == 'Rejected').toList().length;
          cancelledCount = leaveRequests.where((element) => element.status == 'Cancelled').toList().length;
          typeSwitch = 1;
        } else {
          for(var ss in response['message']['data']) {
            if(ss['status'] != null) {
              shiftRequests.add(ShiftRequestsModel.fromJson(ss));
            }
          }
          for(var ss in shiftRequests) {
            if(ss.status == 'Open') {
              ss.status = 'Draft';
            }
          }
          draftCount = shiftRequests.where((element) => element.status == 'Draft').toList().length;
          approvedCount = shiftRequests.where((element) => element.status == 'Approved').toList().length;
          rejectedCount = shiftRequests.where((element) => element.status == 'Rejected').toList().length;
          typeSwitch = 2;
        }
        emit(ReportLoaded());
      }
      emit(ReportLoaded());
    }catch(e) {
      reportLoading = false;
      emit(ReportError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  getAttendance(context) async{
    final instance = DataHelper.instance;
    Map<String, dynamic> body = {
      'employee_id': '${instance.userId}',
    };
    if(fromDate != null && toDate != null) {
      body['from_date'] = fromDate;
      body['to_date'] = toDate;
    }
    if(currAttendanceFilter != null && currAttendanceFilter != 'All') {
      body['status'] = currAttendanceFilter;
    }
    reportLoading = true;
    emit(ReportLoading());
    try {
      final response = await HTTPHelper.httpPost(EndPoints.getAttendaceReport, body, context);
      reportLoading = false;
      if(response['message']['status'] == 'success') {
        present = response['message']['data']['status_counts']['Present'] ?? 0;
        absent = response['message']['data']['status_counts']['Absent'] ?? 0;
        onLeave = response['message']['data']['status_counts']['On Leave'] ?? 0;
        workFromHome = response['message']['data']['status_counts']['Work From Home'] ?? 0;
        attendance = [];
        attendance = (response['message']['data']['attendance_list'] as List).map((e) => AttendanceModel.fromJson(e)).toList();
        emit(ReportLoaded());
      }
      emit(ReportLoaded());
    }catch(e) {
      reportLoading = false;
      emit(ReportError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  getOverTimes(context) async{
    if(fromDate == null || toDate == null) {
      ToastWidget().showToast('Please select a date range', context);
      return;
    }
    final instance = DataHelper.instance;
    final body = {
      'employee_id': '${instance.userId}',
      'start_date': fromDate,
      'end_date': toDate,
    };
    reportLoading = true;
    emit(ReportLoading());
    try {
      final response = await HTTPHelper.httpPost(EndPoints.getOvertimeReport, body, context);
      reportLoading = false;
      if(response['message']['status'] == 'success') {
        overtimeList = [];
        overtimeList = (response['message']['overtimes'] as List).map((e) => OvertimeModel.fromJson(e)).toList();
      }
      emit(ReportLoaded());
    }catch(e) {
      reportLoading = false;
      emit(ReportError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
}
