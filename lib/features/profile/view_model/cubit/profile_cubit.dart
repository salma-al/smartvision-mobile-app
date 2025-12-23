// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_vision/core/helper/cache_helper.dart';
import 'package:smart_vision/core/helper/http_helper.dart';
import 'package:smart_vision/core/helper/shared_functions.dart';
import 'package:smart_vision/core/utils/end_points.dart';
import 'package:smart_vision/core/widgets/toast_widget.dart';
import 'package:smart_vision/features/profile/model/main_salary_model.dart';
import 'package:smart_vision/features/profile/model/profile_company_model.dart';
import 'package:smart_vision/features/profile/model/profile_info_model.dart';
import 'package:smart_vision/features/profile/model/salary_details_model.dart';

import '../../../../core/helper/data_helper.dart';
import '../../view/profile_salary_details_screen.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  ///main screen part
  getProfileMainData(BuildContext context) async {
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpPost(EndPoints.profileMainData, body, context);
      if(response['message']['status'] == 'success') {
        final data = response['message']['data'];
        String shiftStart = data['default_shift_start'].toString();
        String shiftEnd = data['default_shift_end'].toString();
        String shiftTime = '${shiftStart.length == 8 ? shiftStart.substring(0, 5) : shiftStart.substring(0, 4)} - ${shiftEnd.length == 8 ? shiftEnd.substring(0, 5) : shiftEnd.substring(0, 4)}';
        DateTime join = DateTime.tryParse(data['date_of_joining']) ?? DateTime.now();
        String joinDate = '${join.day} ${getMonthName(join.month)} ${join.year}';
        emit(MainProfileLoaded(joinDate, shiftTime));
      }
    }catch(e){
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  ///personal info part
  getProfileInfo(context) async{
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId};
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpPost(EndPoints.getProfile, body, context);
      if(response['message']['status'] == 'success') {
        emit(PersonalInfoLoaded(ProfileInfoModel.fromJson(response['message']['data'])));
        instance.img = response['message']['data']['image'] == null ? instance.img : '${HTTPHelper.fileBaseUrl}${response['message']['data']['image']}';
        await CacheHelper.setData('img', instance.img);
      }
    }catch(e){
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  ///company info part
  getCompanyProfile(context) async{
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpGet('${EndPoints.getCompany}?employee_id=${DataHelper.instance.userId}', context);
      if(response['message']['status'] == 'success') {
        emit(CompanyLoaded(ProfileCompanyModel.fromJson(response['message']['data'])));
      }
    }catch(e){
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  ///salaries info part
  List<String> availableYears = List.generate(5, (index) => (DateTime.now().year - index).toString());
  String selectedYear = DateTime.now().year.toString();
  MainSalaryModel? salary;

  changeSalaryYear(String year, context) async{
    selectedYear = year;
    await getSalriesProfile(context);
  }
  getSalriesProfile(context) async{
    final instance = DataHelper.instance;
    final body = {'employee_id': instance.userId, 'year': selectedYear};
    // final body = {'employee_id': 'SVG-014', 'year': selectedYear};
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpPost(EndPoints.getSalaries, body, context);
      if(response['message']['status'] == 'success') {
        salary = MainSalaryModel.fromJson(response['message']);
        emit(ProfileLoaded());
      }
    }catch(e){
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
  getSalryDetails(context, id) async{
    final body = {'salary_slip_id': id};
    emit(ProfileLoading());
    try{
      final response = await HTTPHelper.httpPost(EndPoints.getSalaryDetails, body, context);
      if(response['message']['status'] == 'success') {
        SalaryDetailsModel? salaryDetailsModel;
        salaryDetailsModel = SalaryDetailsModel.fromJson(response['message']['details']);
        emit(ProfileLoaded());
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSalaryDetailsScreen(details: salaryDetailsModel!)));
      }
    }catch(e){
      emit(ProfileError());
      ToastWidget().showToast('Something went wrong', context);
    }
  }
}