import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/features/announcement/model/announcements_model.dart';

part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  AnnouncementCubit() : super(AnnouncementInitial());

  static AnnouncementCubit get(context) => BlocProvider.of(context);

  List<AnnouncementsModel> announcements = [];
  bool loading = false;
  AnnouncementsModel? singleAnnouncement;

  getAllAnnouncements(context) async {
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    emit(AnnouncementLoading());
    try {
      final data = await HTTPHelper.httpPost(EndPoints.getAnnouncements, body, context);
      if(data['message']['status'] == 'success') {
        announcements.clear();
        announcements = (data['message']['data'] as List).map((e) => AnnouncementsModel.fromJson(e)).toList();
        emit(AnnouncementLoaded());
      }
    } catch (e) {
      emit(AnnouncementError());
    }
  }
}
