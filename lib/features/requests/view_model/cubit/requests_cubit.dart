// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/helper/shared_functions.dart';
import '../../../../core/widgets/toast_widget.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/http_helper.dart';
import '../../../../core/utils/end_points.dart';
import '../../model/request_model.dart';

part 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  RequestsCubit() : super(RequestsInitial());

  static RequestsCubit get(context) => BlocProvider.of(context);

  String lastFromDate = generateDateString(DateTime(DateTime.now().year, DateTime.now().month, 1)), lastToDate = generateDateString(DateTime.now());
  String lastFilterType = '';
  bool lastNeedActionVal = true;
  List<RequestModel> requests = [];

  getRequests(BuildContext context, [String? from, String? to, String? type, bool? needAction]) async {
    if(from != null) lastFromDate = from;
    if(to != null) lastToDate = to;
    if(type != null) lastFilterType = type;
    if(needAction != null) lastNeedActionVal = needAction;
    try {
      emit(RequestsLoading());
      final instance = DataHelper.instance;
      final body = {
        'employee_id': instance.userId, 
        'pending_only': lastNeedActionVal ? '1' : '0',
        'from_date': lastFromDate,
        'to_date': lastToDate,
      };
      if(lastFilterType.isNotEmpty && lastFilterType.toLowerCase() != 'all') body['request_type'] = lastFilterType.toLowerCase();
      final data = await HTTPHelper.httpPost(EndPoints.getRequests, body, context);
      if(data['message']['data'] != null) {
        requests.clear();
        bool show = false;
        for(var req in data['message']['data']) {
          show = (instance.isHr && req['status'] == 'Manager Approved') || (instance.isManager && req['status'] == 'Requested');
          if(lastNeedActionVal) {
            if(show) requests.add(RequestModel.fromJson(req, show));
          } else {
            requests.add(RequestModel.fromJson(req, show));
          }
        }
      }
    } catch (e) {
      ToastWidget().showToast('Something went wrong', context);
    }
    emit(RequestsLoaded());
  }
  updateRequest(BuildContext context, RequestModel req, String status) async {
    try {
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
        requests.remove(req);
      }else {
        ToastWidget().showToast(data['message']['message'] ?? 'Failed to update request', context);
      }
    } catch (e) {
      ToastWidget().showToast('Failed to update request', context);
    }
    emit(RequestsLoaded());
  }
}