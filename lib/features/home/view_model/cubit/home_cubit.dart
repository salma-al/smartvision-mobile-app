// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/cache_helper.dart';
import '../../../../core/helper/data_helper.dart';
import '../../../../core/helper/http_helper.dart';
import '../../../../core/utils/end_points.dart';
import '../../../login/view/login_screen.dart';
import '../../model/home_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getHomeData(BuildContext context) async {
    try {
      final instance = DataHelper.instance;
      final data = await HTTPHelper.httpPost(EndPoints.availableRequests, {'employee_id': instance.userId}, context);
      if(data['message']['has_log_date'] == false) {
        String email = await CacheHelper.getData('email', String) ?? '';
        String password = await CacheHelper.getData('password', String) ?? '';
        await CacheHelper.removeAllData();
        await CacheHelper.setData('email', email);
        await CacheHelper.setData('password', password);
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
        return;
      }
      if(data['status'] == 'fail') {
        emit(HomeError(data['message'] ?? 'Something went wrong'));
        return;
      }
      instance.isHr = data['message']['is_hr'] ?? false;
      instance.isManager = data['message']['is_direct_manager'] ?? false;
      DataHelper.unreadNotificationCount = data['message']['unseen_notifications_count'] ?? 0;
      emit(HomeLoaded(HomeModel.fromJson(data['message'])));
    } catch(e) {
      emit(HomeError(e.toString()));
    }
  }
}
