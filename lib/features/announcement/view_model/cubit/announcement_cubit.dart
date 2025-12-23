import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/features/announcement/model/announcements_model.dart';

import '../../../../core/helper/shared_functions.dart';

part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  AnnouncementCubit() : super(AnnouncementInitial());

  List<AnnouncementsModel> announcements = [];
  String lastFromDate = generateDateString(DateTime(DateTime.now().year, DateTime.now().month, 1)), lastToDate = generateDateString(DateTime.now());

  getAllAnnouncements(context, [String? from, String? to]) async {
    if(from != null) lastFromDate = from;
    if(to != null) lastToDate = to;
    final body = {
      'employee_id': DataHelper.instance.userId,
      'start_date': lastFromDate,
      'end_date': lastToDate,
    };
    emit(AnnouncementLoading());
    try {
      final data = await HTTPHelper.httpPost(EndPoints.getAnnouncements, body, context);
      if(data['message']['status'] == 'success') {
        announcements.clear();
        announcements = (data['message']['data'] as List).map((e) => AnnouncementsModel.fromJson(e)).toList();
        announcements.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
        emit(AnnouncementLoaded());
      }
    } catch (e) {
      emit(AnnouncementError());
    }
  }
}