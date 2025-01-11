class AttendanceModel {
  final String date, status;

  AttendanceModel({required this.date, required this.status});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(date: json['attendance_date'], status: json['status']);
  }
}