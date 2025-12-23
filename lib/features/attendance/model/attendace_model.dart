class AttendanceModel {
  int present, absent, leave, halfDay, workFromHome;
  final List<DailyCheck> dailyData;

  AttendanceModel({
    required this.present, 
    required this.absent, 
    required this.leave, 
    required this.halfDay, 
    required this.workFromHome, 
    required this.dailyData,
  });

  factory AttendanceModel.fromJson(Map json) {
    return AttendanceModel(
      present: json['present'], 
      absent: json['absent'], 
      leave: json['on_leave'], 
      halfDay: json['half_day'], 
      workFromHome: json['work_from_home'], 
      dailyData: List<DailyCheck>.from(json['daily_data'].map((e) => DailyCheck.fromJson(e))),
    );
  }
}

class DailyCheck {
  final int dayNum;
  final String dayName, status;
  final bool hasChecked;
  final String? inTime, outTime, totalHours, reason;

  DailyCheck({
    required this.dayNum, 
    required this.dayName, 
    required this.status, 
    required this.hasChecked, 
    required this.inTime, 
    required this.outTime, 
    required this.totalHours, 
    required this.reason,
  });

  factory DailyCheck.fromJson(Map json) {
    return DailyCheck(
      dayNum: json['day_number'], 
      dayName: json['day_of_week'], 
      status: json['status'], 
      hasChecked: json['has_checkin'] ?? false, 
      inTime: json['check_in'], 
      outTime: json['check_out'], 
      totalHours: json['total_hours'], 
      reason: json['reason'],
    );
  } 
}