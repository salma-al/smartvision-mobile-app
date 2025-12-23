import 'package:smart_vision/core/helper/data_helper.dart';
import 'package:smart_vision/core/helper/shared_functions.dart';

class ProfileInfoModel {
  final String email, shift, joinDate, breakHours, jobTitle, dep, isActive, employmentType;
  final String managerName, managerTitle, managetMail, workLocation;

  ProfileInfoModel({
    required this.email, 
    required this.shift, 
    required this.joinDate, 
    required this.breakHours, 
    required this.jobTitle, 
    required this.dep, 
    required this.isActive, 
    required this.employmentType, 
    required this.managerName, 
    required this.managerTitle, 
    required this.managetMail, 
    required this.workLocation,
  });

  factory ProfileInfoModel.fromJson(Map json) {
    String shift = '${json['default_shift_start'].toString().substring(0, 6)} - ${json['default_shift_end'].toString().substring(0, 6)}';
    DateTime join = DateTime.tryParse(json['date_of_joining']) ?? DateTime.now();
    String joinDate = '${getMonthName(join.month)} ${join.day.toString().padLeft(2, '0')}, ${join.year}';
    String breakHoues = '${json['break_start_time'] ?? ''} - ${json['break_end_time'] ?? ''}';
    return ProfileInfoModel(
      email: DataHelper.instance.email ?? '', 
      shift: shift, 
      joinDate: joinDate, 
      breakHours: breakHoues, 
      jobTitle: json['position'], 
      dep: json['department'], 
      isActive: json['employee_status'] ?? '',
      employmentType: json['employment_type'] ?? '',
      managerName: json['manager'], 
      managerTitle: json['manager_designation'], 
      managetMail: json['manager_user_id'], 
      workLocation: json['manager_working_location'],
    );
  }
}