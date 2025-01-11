import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/cache_helper.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import 'package:smart_vision/features/profile/model/main_salary_model.dart';
import 'package:smart_vision/features/profile/model/salary_details_model.dart';

import '../../../../core/helper/data_helper.dart';
import '../../view/profile_salary_details_screen.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  ///personal info part
  String? position, department, manager, employmentType, joiningDate, startShift, endShift;
  ///company info part
  String? company, branch, description, lat, long, distance;
  ///salaries info part
  List<int> availableYears = List.generate(5, (index) => DateTime.now().year - index);
  int selectedYear = DateTime.now().year;
  List<MainSalaryModel> salaryList = [];
  ///
  bool profileLoading = false;

  getProfile(context) async{
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    profileLoading = true;
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpPost(EndPoints.getProfile, body, context);
      profileLoading = false;
      if(response['message']['status'] == 'success') {
        position = response['message']['data']['position'];
        department = response['message']['data']['department'];
        manager = response['message']['data']['manager'];
        employmentType = response['message']['data']['employment_type'];
        joiningDate = response['message']['data']['date_of_joining'];
        startShift = response['message']['data']['default_shift_start'];
        endShift = response['message']['data']['default_shift_end'];
        instance.img = response['message']['data']['image'] == null ? instance.img : '${HTTPHelper.imgBaseUrl}${response['message']['data']['image']}';
        await CacheHelper.setData('img', instance.img);
      }
      emit(ProfileLoaded());
    }catch(e){
      profileLoading = false;
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  getCompanyProfile(context) async{
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    profileLoading = true;
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpPost(EndPoints.getCompany, body, context);
      profileLoading = false;
      if(response['message']['status'] == 'success') {
        company = response['message']['data']['company'];
        branch = response['message']['data']['branch'];
        description = response['message']['data']['description'];
        lat = response['message']['data']['latitude'];
        long = response['message']['data']['longitude'];
        distance = response['message']['data']['distance'];
      }
      emit(ProfileLoaded());
    }catch(e){
      profileLoading = false;
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  changeSalaryYear(int year, context) async{
    selectedYear = year;
    await getSalriesProfile(context);
  }
  getSalriesProfile(context) async{
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId, 'year': selectedYear.toString()};
    profileLoading = true;
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpPost(EndPoints.getSalaries, body, context);
      profileLoading = false;
      if(response['message']['status'] == 'success') {
        salaryList = [];
        for(var sal in response['message']['salaries']) {
          if(sal['status'] == 'Submitted') {
            salaryList.add(MainSalaryModel.fromJson(sal));
          }
        }
      }
      emit(ProfileLoaded());
    }catch(e){
      profileLoading = false;
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  getSalryDetails(context, id) async{
    final body = {'salary_slip_id': id};
    profileLoading = true;
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpPost(EndPoints.getSalaryDetails, body, context);
      profileLoading = false;
      SalaryDetailsModel? salaryDetailsModel;
      if(response['message']['status'] == 'success') {
        salaryDetailsModel = SalaryDetailsModel.fromJson(response['message']['details']);
      }
      if(salaryDetailsModel != null) {
        emit(ProfileLoaded());
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSalaryDetailsScreen(salaryDetailsModel: salaryDetailsModel!)));
      }else {
        ToastWidget().showToast('Something went wrong', context);
      }
      emit(ProfileLoaded());
    }catch(e){
      profileLoading = false;
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
}
