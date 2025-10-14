// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/toast_widget.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/http_helper.dart';
import '../../../../core/utils/end_points.dart';
import '../../model/request_model.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsInitial());

  static RequestsCubit get(context) => BlocProvider.of(context);

  bool loading = false;
  List<RequestModel> requests = [], filteredRequests = [];
  String? fromDate, toDate, fromDateValue, toDateValue, selectedRequestType;
  bool needAction = true, actionCheckBox = true;
  bool isFilterExpanded = false;

  getRequests(BuildContext context) async {
    try {
      loading = true;
      emit(RequestsLoading());
      needAction = actionCheckBox;
      final instance = DataHelper.instance;
      final body = {'employee_id': instance.userId, 'pending_only': needAction ? '1' : '0'};
      if(fromDateValue != null) body['from_date'] = fromDateValue;
      if(toDateValue != null) body['to_date'] = toDateValue;
      if(selectedRequestType!= null && selectedRequestType!= 'All') body['request_type'] = selectedRequestType;
      final data = await HTTPHelper.httpPost(EndPoints.getRequests, body, context);
      if(data['message']['data'] != null) {
        requests.clear();
        bool show = false;
        for(var req in data['message']['data']) {
          show = (instance.isHr && req['status'] == 'Manager Approved') || (instance.isManager && req['status'] == 'Requested');
          if(needAction) {
            if(show) requests.add(RequestModel.fromJson(req, show));
          } else {
            requests.add(RequestModel.fromJson(req, show));
          }
        }
        filteredRequests = requests;
      }
    } catch (e) {
      ToastWidget().showToast('Something went wrong', context);
    }
    loading = false;
    emit(RequestsLoaded());
  }
  updateRequest(BuildContext context, RequestModel req, String status) async {
    try {
      loading = true;
      emit(RequestsLoading());
      final instance = DataHelper.instance;
      final body = {
        'employee_id': instance.userId,
        'request_name': req.id,
        'doctype': req.docType,
        'status': status,
        'reason': '',
      };
      final data = await HTTPHelper.httpPost(EndPoints.updateRequest, body, context);
      if(data['message']['status'] == 'success') {
        req.status = req.status.toLowerCase() == 'requested' ? 'Manager Approved' : 'Approved';
        ToastWidget().showToast('Request ${status.toLowerCase()}', context);
      }else {
        ToastWidget().showToast(data['message']['message'] ?? 'Failed to update request', context);
      }
      emit(RequestsLoaded());
    } catch (e) {
      ToastWidget().showToast('Failed to update request', context);
    }
    loading = false;
    emit(RequestsLoaded());
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
        fromDateValue = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
      } else {
        toDate = '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
        toDateValue = '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
      }
      emit(RequestDateChanged());
    }
  }
  toggleFilter() {
    isFilterExpanded = !isFilterExpanded;
    emit(RequestsFilterToggled());
  }
  changeRequestType(String? type) {
    selectedRequestType = type;
    emit(RequestsTypeChanged());
  }
  toggleNeedAction(bool value) {
    actionCheckBox = value;
    emit(RequestsNeedActionToggled());
  }
}