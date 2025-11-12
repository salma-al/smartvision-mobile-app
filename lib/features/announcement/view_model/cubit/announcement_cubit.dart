import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/features/announcement/model/announcements_model.dart';

part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  AnnouncementCubit() : super(AnnouncementInitial());

  List<AnnouncementsModel> announcements = [];

  getAllAnnouncements(context) async {
    final body = {'employee_id': DataHelper.instance.userId};
    emit(AnnouncementLoading());
    try {
      final data = await HTTPHelper.httpPost(EndPoints.getAnnouncements, body, context);
      debugPrint(jsonEncode(data['message']['data'][0]['attachments']));
      if(data['message']['status'] == 'success') {
        announcements.clear();
        announcements = (data['message']['data'] as List).map((e) => AnnouncementsModel.fromJson(e)).toList();
        announcements.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
        emit(AnnouncementLoaded(announcements: announcements));
      }
    } catch (e) {
      emit(AnnouncementError());
    }
  }
}