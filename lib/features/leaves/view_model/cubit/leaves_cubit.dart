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
    if(start) {
      startTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      startTimeController.text = startTime == null ? '' : '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
    }else {
      endTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      endTimeController.text = endTime == null ? '' : '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
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
        shiftsTypes = [
          LeaveTypesModel(leaveType: 'Work From Home', availableLeaves: 0),
        ];
        leaveTypes.add(LeaveTypesModel(leaveType: 'Leave Without Pay', availableLeaves: 0));
        for (var leave in data['message']['data']) {
          leaveTypes.add(LeaveTypesModel.fromJson(leave));
        }
        if(data['message']['shifts'] == true) {
          shiftsTypes.add(LeaveTypesModel(leaveType: 'Late Excuse', availableLeaves: 0));
          shiftsTypes.add(LeaveTypesModel(leaveType: 'Early Excuse', availableLeaves: 0));
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
