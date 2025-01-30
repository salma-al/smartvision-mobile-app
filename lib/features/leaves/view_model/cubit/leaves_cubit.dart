// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import 'package:smart_vision/features/leaves/model/leave_types_model.dart';

import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/http_helper.dart';

part 'leaves_state.dart';

class LeavesCubit extends Cubit<LeavesState> {
  LeavesCubit() : super(LeavesInitial());

  static LeavesCubit get(context) => BlocProvider.of(context);
  bool leavesLoading = false;
  DateTime? startDate, endDate;
  TimeOfDay? startTime, endTime;
  List<LeaveTypesModel> leaveTypes = [];
  List<LeaveTypesModel> shiftsTypes = [];
  List<LeaveTypesModel> selectedTypeList = [];
  LeaveTypesModel? currentLeaveType;
  String currentRequestType = 'Leave';
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String shownRequestType = 'Leave Type';

  changeRequestType(String type) {
    currentRequestType = type;
    shownRequestType = type == 'Leave' ? 'Leave Type' : 'Shift Type';
    selectedTypeList = type == 'Leave' ? leaveTypes : shiftsTypes;
    currentLeaveType = null;
    emit(RequestChanged());
  }
  pickDate(bool start, BuildContext context) async{
    if(start) {
      startDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2050));
      startDateController.text = startDate == null ? '' : startDate.toString().split(' ')[0];
    }else {
      endDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2050));
      endDateController.text = endDate == null ? '' : endDate.toString().split(' ')[0];
    }
  }
  pickTime(bool start, BuildContext context) async{
    int currentDay = DateTime.now().day;
    TimeOfDay minTime = const TimeOfDay(hour: 18, minute: 0);
    TimeOfDay maxTime = const TimeOfDay(hour: 23, minute: 59);

    if (currentDay == DateTime.friday || currentDay == DateTime.saturday) {
      minTime = const TimeOfDay(hour: 0, minute: 0);
      maxTime = const TimeOfDay(hour: 23, minute: 59);
    }

    TimeOfDay? time = await showTimePicker(context: context, initialTime: minTime);
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
  getAvailableLeaves(context) async{
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    leavesLoading = true;
    emit(LeavesLoadingState());
    try {
      final data = await HTTPHelper.httpPost(EndPoints.getLeaves, body, context);
      if(data['message']['status'] == 'success') {
        leaveTypes.clear();
        shiftsTypes.clear();
        currentRequestType = 'Leave';
        shownRequestType = 'Leave Type';
        leaveTypes.add(LeaveTypesModel(leaveType: 'Leave Without Pay', availableLeaves: 0));
        for (var leave in data['message']['data']) {
          leaveTypes.add(LeaveTypesModel.fromJson(leave));
        }
        for (var shift in data['message']['shifts']) {
          shiftsTypes.add(LeaveTypesModel(leaveType: shift['name'], availableLeaves: 0));
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
  submitRequest(context) async{
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId,
      'sub_type': currentLeaveType!.leaveType,
      'start_date': startDateController.text,
      'end_date': endDateController.text,
      'type': currentRequestType,
      'reason': reasonController.text
    };
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
        ToastWidget().showToast(data['message']['message'], context);
      }
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  submitRequestOvertime(context) async{
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
