// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/shared_functions.dart';

import '../../../../core/utils/end_points.dart';
import '../../../../core/widgets/toast_widget.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/http_helper.dart';
import '../../model/overtime_model.dart';
import '../../model/shift_model.dart';
import '../../model/leave_model.dart';
import '../../model/leave_types_model.dart';

part 'leaves_state.dart';

class LeavesCubit extends Cubit<LeavesState> {
  LeavesCubit() : super(LeavesInitial());

  static LeavesCubit get(context) => BlocProvider.of(context);

  bool leavesLoading = false;
  int tabIndex = 0;
  TextEditingController reasonController = TextEditingController();
  DateTime startDate = DateTime.now(), endDate = DateTime.now();
  String lastFromDate = generateDateString(DateTime(DateTime.now().year, DateTime.now().month, 1)), lastToDate = generateDateString(DateTime.now());
  String lastSelectedFilter = '';

  String generateDate(DateTime date) => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  changeDate(DateTime picked, bool isStart) {
    isStart ? startDate = picked : endDate = picked;
    emit(DateChanged());
  }
  changeTab(int tab) {
    tabIndex = tab;
    emit(TabChanged());
  }
  //shift screen
  List<String> excuseTimes = [];
  String selectedShift = 'Work From Home', excuseTime = '', excuseType = '';
  List<ShiftModel> shiftRecords = [];

  changeShift(String shift) {
    selectedShift = shift;
    emit(ShiftChanged());
  }
  changeExcuseTime(String time) {
    excuseTime = time;
    emit(ExcuseTimeChanged());
  }
  changeExcuseType(String type) {
    excuseType = type;
    emit(ExcuseTypeChanged());
  }
  submitShift(BuildContext context) async {
    if(reasonController.text.isEmpty || selectedShift.isEmpty) {
      ToastWidget().showToast('Please fill all the fields', context);
      return;
    }
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId ?? '0',
      'shift_type': selectedShift,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'reason': reasonController.text,
    };
    if((excuseTime.isEmpty || excuseType.isEmpty) && selectedShift.toLowerCase().contains('excuse')) {
      ToastWidget().showToast('Please select excuse', context);
      return;
    }
    if(excuseTime.isNotEmpty && excuseType.isNotEmpty && selectedShift.toLowerCase().contains('excuse')) {
      body['excuse_time'] = excuseTime.split(' ')[0];
      body['excuse_type'] = excuseType;
    }
    leavesLoading = true;
    emit(LeavesLoadingState());
    try{
      dynamic data = await HTTPHelper.httpPost(EndPoints.shiftCreate, body, context);
      leavesLoading = false;
      final message = data['message'] ?? data['data']?['message'];
      final status = message?['status'];
      final msgText = message?['message'] ?? 'Request completed';

      if (status == 'success') {
        emit(LeavesLoadedState());
        ToastWidget().showToast(msgText, context);
        changeTab(1);
      } else {
        emit(LeavesErrorState());
        ToastWidget().showToast(
          msgText.isEmpty ? 'Failed to submit your request' : msgText,
          context,
        );
      }
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  filterShiftHistory(BuildContext context, [String? type, String? from, String? to]) async {
    if(from != null) lastFromDate = from;
    if(to != null) lastToDate = to;
    if(type != null) lastSelectedFilter = type;
    leavesLoading = true;
    final body = {
      'employee_id': DataHelper.instance.userId ?? '0',
      'from_date': lastFromDate,
      'to_date': lastToDate,
    };
    if(lastSelectedFilter.toLowerCase() != 'all' && lastSelectedFilter.isNotEmpty) body['shift_type'] = lastSelectedFilter;
    emit(LeavesLoadingState());
    try{
      dynamic data = await HTTPHelper.httpPost(EndPoints.shiftHistory, body, context);
      excuseTimes = List<String>.from(data['message']['excuse_times'].map((e) => e.toString()));
      shiftRecords = List<ShiftModel>.from(data['message']['data'].map((e) => ShiftModel.fromJson(e)));
      leavesLoading = false;
      emit(LeavesLoadedState());
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  //leave screen
  List<LeaveTypesModel> leaveTypes = [];
  List<LeaveModel> leaveRecords = [];
  LeaveTypesModel? selectedLeaveType;
  File? attach;
  double? uploadPercentage;

  changeLeaveType(String type) {
    selectedLeaveType = leaveTypes.where((e) => e.leaveType == type).first;
    emit(LeaveTypeChanged());
  }
  pickFile() async {
    final file = await FilePicker.platform.pickFiles();
    if(file == null) return;
    attach = File(file.files.single.path!);
    emit(FilePicked());
  }
  removeFile() {
    attach = null;
    emit(FilePicked());
  }
  filterLeaveHistory(BuildContext context, [String? type, String? from, String? to]) async {
    leavesLoading = true;
    if(from != null) lastFromDate = from;
    if(to != null) lastToDate = to;
    if(type != null) lastSelectedFilter = type;
    String path = '?employee_id=${DataHelper.instance.userId}';
    path += '&from_date=$lastFromDate';
    path += '&to_date=$lastToDate';
    if(lastSelectedFilter.isNotEmpty && lastSelectedFilter.toLowerCase() != 'all') path += '&leave_type=$type';
    emit(LeavesLoadingState());
    try{
      final data = await HTTPHelper.httpGet('${EndPoints.leaveHistory}$path', context);
      if(data != null) {
        leaveRecords = List<LeaveModel>.from(data['message']['data'].map((e) => LeaveModel.fromJson(e)));
        leaveTypes = List<LeaveTypesModel>.from(data['message']['available_leaves']['data'].map((e) => LeaveTypesModel.fromJson(e)));
      }
      leavesLoading = false;
      emit(LeavesLoadedState());
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  submitLeave(BuildContext context) async {
    if(reasonController.text.isEmpty || selectedLeaveType == null) {
      ToastWidget().showToast('Please fill all the fields', context);
      return;
    }
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId ?? '0',
      'leave_type': selectedLeaveType!.leaveType,
      'start_date': generateDateString(startDate),
      'end_date': generateDateString(endDate),
      'reason': reasonController.text,
    };
    leavesLoading = true;
    emit(LeavesLoadingState());
    try{
      dynamic data;
      if(attach != null) {
        data = await HTTPHelper.uploadFilesWithProgress(context: context, file: attach!, endPoint: EndPoints.leaveCreate, imgKey: 'attachment', body: body, onProgress: (progress) {
          uploadPercentage = progress;
          emit(LeavesLoadingState());
        });
        uploadPercentage = null;
        attach = null;
      } else {
        data = await HTTPHelper.httpPost(EndPoints.leaveCreate, body, context);
      }
      leavesLoading = false;
      final message = data['message'] ?? data['data']?['message'];
      final status = message?['status'];
      final msgText = message?['message'] ?? 'Request completed';

      if (status == 'success') {
        emit(LeavesLoadedState());
        ToastWidget().showToast(msgText, context);
        changeTab(1);
      } else {
        emit(LeavesErrorState());
        ToastWidget().showToast(
          msgText.isEmpty ? 'Failed to submit your request' : msgText,
          context,
        );
      }
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  //overtime screen
  TimeOfDay overtimeStartTime = TimeOfDay.now(), overtimeEndTime = TimeOfDay.now();
  List<OvertimeModel> overtimeRecords = [];

  changeOvertimeTime(TimeOfDay time, bool isStart) {
    isStart ? overtimeStartTime = time : overtimeEndTime = time;
    emit(TimeChanged());
  }
  filterOvertimeHistory(BuildContext context, [String? status, String? from, String? to]) async {
    if(from != null) lastFromDate = from;
    if(to != null) lastToDate = to;
    if(status != null) lastSelectedFilter = status;
    leavesLoading = true;
    final body = {
      'employee_id': DataHelper.instance.userId ?? '0',
      'start_date': lastFromDate,
      'end_date': lastToDate,
    };
    if(lastSelectedFilter.isNotEmpty && lastSelectedFilter.toLowerCase() != 'all') body['status'] = lastSelectedFilter;
    emit(LeavesLoadingState());
    try{
      dynamic data = await HTTPHelper.httpPost(EndPoints.overtimeHistory, body, context);
      overtimeRecords = List<OvertimeModel>.from(data['message']['overtimes'].map((e) => OvertimeModel.fromJson(e)));
      leavesLoading = false;
      emit(LeavesLoadedState());
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  submitOvertime(BuildContext context) async {
    final instance = DataHelper.instance;
    final body = {
      'employee_id': instance.userId ?? '0',
      'date': '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}',
      'start_time': overtimeStartTime.format(context).substring(0, 5),
      'end_time': overtimeEndTime.format(context).substring(0, 5),
      'reason': reasonController.text,
    };
    leavesLoading = true;
    emit(LeavesLoadingState());
    try{
      dynamic data = await HTTPHelper.httpPost(EndPoints.overtimeCreate, body, context);
      leavesLoading = false;
      final message = data['message'] ?? data['data']?['message'];
      final status = message?['status'];
      final msgText = message?['message'] ?? 'Request completed';

      if (status == 'success') {
        emit(LeavesLoadedState());
        ToastWidget().showToast(msgText, context);
        changeTab(1);
      } else {
        emit(LeavesErrorState());
        ToastWidget().showToast(
          msgText.isEmpty ? 'Failed to submit your request' : msgText,
          context,
        );
      }
    }catch (e) {
      leavesLoading = false;
      emit(LeavesErrorState());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
}