import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/features/notification/model/notification_model.dart';

import '../../../../core/helper/data_helper.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  static NotificationCubit get(context) => BlocProvider.of(context);

  List<NotificationModel> notifications = [];
  bool loading = false;

  getNotifications(BuildContext context) async {
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    loading = true;
    emit(NotificationLoading());
    try {
      final data = await HTTPHelper.httpPost(EndPoints.getNotifications, body, context);
      if(data['message']['status'] == 'success') {
        notifications.clear();
        notifications = List<NotificationModel>.from(data['message']['data'].map((x) => NotificationModel.fromJson(x)));
        loading = false;
        emit(NotificationLoaded());
      }
    }catch (e) {
      loading = false;
      emit(NotificationError());
    }
  }
}
