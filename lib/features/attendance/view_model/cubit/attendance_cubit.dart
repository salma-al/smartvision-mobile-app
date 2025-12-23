import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/http_helper.dart';
import '../../../../core/utils/end_points.dart';
import '../../../../core/widgets/toast_widget.dart';
import '../../../../core/constants/app_constants.dart';
import '../../model/attendace_model.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  static AttendanceCubit get(context) => BlocProvider.of(context);

  String selectedType = 'All';
  int selectedMonth = DateTime.now().month;
  List<String> monthNames = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];  
  AttendanceModel? attendance;

  Color statusColor(String status) {
    switch (status) {
      case 'Present':
        return AppColors.green;
      case 'Absent':
        return AppColors.red;
      case 'On Leave':
        return AppColors.yellow;
      default:
        return AppColors.blue;
    }
  }
  Color statusBgColor(String status) {
    switch (status) {
      case 'Present':
        return AppColors.lightGreen;
      case 'Absent':
        return AppColors.lightRed;
      case 'On Leave':
        return AppColors.lightYellow;
      default:
        return AppColors.lightBlue;
    }
  }
  Color reasonColor(String reason) {
    switch (reason.toLowerCase()) {
      case 'execuse':
        return AppColors.orange;
      case 'mission':
        return AppColors.blue;
      default:
        return AppColors.purple;
    }
  }
  void changeMonth(String month) {
    selectedMonth = monthNames.indexOf(month) + 1;
    emit(MonthChanged());
  }
  void changeType(String type) {
    selectedType = type;
    emit(TypeSelected());
  }
  Future<void> getAttendaceStatistics(context) async {
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId!,
      'year': DateTime.now().year.toString(),
      'month': selectedMonth.toString(),
    };
    emit(AttendanceLoading());
    try{
      final data = await HTTPHelper.httpPost(EndPoints.getAttendance, body, context);
      if(data['message']['status'] == 'success'){
        attendance = AttendanceModel.fromJson(data['message']['data']);
        if(selectedType.toLowerCase() != 'all') {
          attendance!.dailyData.removeWhere((e) => e.status != selectedType);
        }
        emit(AttendanceLoaded());
      }else {
        ToastWidget().showToast('Something went wrong', context);
        emit(AttendanceError());
      }
    }catch(e) {
      ToastWidget().showToast('Something went wrong', context);
      emit(AttendanceError());
    }
  }
}