// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../model/leave_types_model.dart';
import '../../../../core/utils/end_points.dart';
import '../../../../core/widgets/toast_widget.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/http_helper.dart';

part 'leaves_state.dart';

class LeavesCubit extends Cubit<LeavesState> {
  LeavesCubit() : super(LeavesInitial());

  static LeavesCubit get(context) => BlocProvider.of(context);
  bool leavesLoading = false;
  DateTime? startDate, endDate;
  TimeOfDay? startTime, endTime;
  List<LeaveTypesModel> leaveTypes = [], shiftsTypes = [], selectedTypeList = [];
  LeaveTypesModel? currentLeaveType;
  RequestType currentRequestType = RequestType.leave;
  String shownRequestType = 'Leave Type';
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  List<double> availExcusesTimes = [];
  double? selectedExcuseTime;

  changeRequestType(RequestType type) {
    currentRequestType = type;
    shownRequestType = type == RequestType.leave ? 'Leave Type' : 'Shift Type';
    selectedTypeList = type == RequestType.leave ? leaveTypes : shiftsTypes;
    currentLeaveType = null;
    emit(RequestChanged());
  }
  pickDate(bool start, BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initial = (currentRequestType == RequestType.overtime) ? now.subtract(const Duration(days: 100)) : now;
    if(start) {
      startDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: initial, lastDate: DateTime.now().add(const Duration(days: 7000)));
      startDateController.text = startDate == null ? '' : startDate.toString().split(' ')[0];
    }else {
      endDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: initial, lastDate: DateTime.now().add(const Duration(days: 7000)));
      endDateController.text = endDate == null ? '' : endDate.toString().split(' ')[0];
    }
  }
  pickTime(bool start, BuildContext context) async {
    // int currentDay = DateTime.now().day;
    TimeOfDay minTime = const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay maxTime = const TimeOfDay(hour: 23, minute: 59);

    // if (currentDay == DateTime.friday || currentDay == DateTime.saturday) {
    //   minTime = const TimeOfDay(hour: 0, minute: 0);
    //   maxTime = const TimeOfDay(hour: 23, minute: 59);
    // }

    TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    ///first time validation if null
    if(time == null) return;
    ///second time validation if in the available range
    bool isValidTime = (time.hour > minTime.hour || (time.hour == minTime.hour && time.minute >= minTime.minute)) &&
                     (time.hour < maxTime.hour || (time.hour == maxTime.hour && time.minute <= maxTime.minute));

    if (!isValidTime) {
      ToastWidget().showToast('Time must be between ${minTime.hour}:${minTime.minute} and ${maxTime.hour}:${maxTime.minute}', context);
      return;
    }
    String formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    if(start) {
      startTime = time;
      startTimeController.text = formattedTime;
    }else {
      endTime = time;
      endTimeController.text = formattedTime;
    }
    emit(ReuestTimeChanged());
  }
  changeLeaveShiftType(LeaveTypesModel type) {
    currentLeaveType = type;
    emit(RequestChanged());
  }
  changeExcuseTime(double? time) {
    selectedExcuseTime = time;
    emit(RequestChanged());
  }
  getAvailableLeaves(context) async {
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    leavesLoading = true;
    emit(LeavesLoadingState());
    try {
      final data = await HTTPHelper.httpPost(EndPoints.getLeaves, body, context);
      if(data['message']['status'] == 'success') {
        leaveTypes.clear();
        shiftsTypes.clear();
        currentRequestType = RequestType.leave;
        shownRequestType = 'Leave Type';
        leaveTypes.add(LeaveTypesModel(leaveType: 'Leave Without Pay', availableLeaves: 0));
        for (var leave in data['message']['data']) {
          leaveTypes.add(LeaveTypesModel.fromJson(leave));
        }
        for (var shift in data['message']['shifts']) {
          shiftsTypes.add(LeaveTypesModel(leaveType: shift['name'], availableLeaves: 0));
        }
        for(var time in data['message']['excuse_times']) {
          availExcusesTimes.add(double.tryParse(time.toString()) ?? 0);
        }
        selectedTypeList = leaveTypes;
        leavesLoading = false;
        emit(LeavesLoadedState());
      }else {
        leavesLoading = false;
        emit(LeavesErrorState());
        ToastWidget().showToast('Something went wrong', context);
      }
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  submitRequest(context) async {
    if(startDateController.text.isEmpty || endDateController.text.isEmpty || reasonController.text.isEmpty || currentLeaveType == null) {
      ToastWidget().showToast('Please fill all the fields', context);
      return;
    }
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId,
      'sub_type': currentLeaveType!.leaveType,
      'start_date': startDateController.text,
      'end_date': endDateController.text,
      'type': currentRequestType.toString().split('.').last,
      'reason': reasonController.text
    };
    if(currentLeaveType == null && currentLeaveType!.leaveType.toLowerCase().contains('excuse') && currentRequestType == RequestType.leave) {
      ToastWidget().showToast('Please select excuse time', context);
      return;
    }
    if(currentLeaveType != null && currentLeaveType!.leaveType.toLowerCase().contains('excuse') && currentRequestType == RequestType.shift) {
      body['excuse_time'] = selectedExcuseTime.toString();
    }
    leavesLoading = true;
    emit(LeavesLoadingState());
    try{
      final data = await HTTPHelper.httpPost(EndPoints.requestLeave, body, context);
      if(data['message']['status'] == 'success') {
        leavesLoading = false;
        emit(LeavesLoadedState());
        ToastWidget().showToast(data['message']['message'], context);
        Navigator.pop(context);
      }else {
        leavesLoading = false;
        emit(LeavesErrorState());
        ToastWidget().showToast((data['message']['message'] == null || data['message']['message'] == '') ? 'failed to submit your request' : data['message']['message'], context);
      }
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  submitRequestOvertime(context) async {
    if(startDateController.text.isEmpty || startTimeController.text.isEmpty || endTimeController.text.isEmpty || reasonController.text.isEmpty) {
      ToastWidget().showToast('Please fill all the fields', context);
      return;
    }
    ///check if start time is before end time
    if(startTime!.hour > endTime!.hour || (startTime!.hour == endTime!.hour && startTime!.minute > endTime!.minute)) {
      ToastWidget().showToast('Start time must be before end time', context);
      return;
    }
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId,
      'date': startDateController.text,
      'start_time': startTimeController.text,
      'end_time': endTimeController.text,
      'reason': reasonController.text
    };
    leavesLoading = true;
    emit(LeavesLoadingState());
    try{
      final data = await HTTPHelper.httpPost(EndPoints.requestOvertime, body, context);
      if(data['message']['status'] == 'success') {
        leavesLoading = false;
        emit(LeavesLoadedState());
        ToastWidget().showToast(data['message']['message'], context);
        Navigator.pop(context);
      }else {
        leavesLoading = false;
        emit(LeavesErrorState());
        ToastWidget().showToast(data['message']['message'], context);
      }
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
}

enum RequestType {
  leave,
  overtime,
  shift
}