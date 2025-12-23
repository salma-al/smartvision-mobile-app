import 'package:smart_vision/core/helper/shared_functions.dart';

class OvertimeModel {
  final String date, startTime, endTime, status, reason, submitDate;
  final double duration;

  OvertimeModel({
    required this.date, 
    required this.startTime, 
    required this.endTime, 
    required this.status, 
    required this.reason, 
    required this.submitDate, 
    required this.duration,
  });

  factory OvertimeModel.fromJson(Map json) {
    DateTime overDate = DateTime.tryParse(json['day_of_overtime'] ?? '') ?? DateTime.now();
    DateTime reqDate = DateTime.tryParse(json['request_date'] ?? '') ?? DateTime.now();
    return OvertimeModel(
      date: '${getMonthName(overDate.month)} ${overDate.day.toString().padLeft(2, '0')}', 
      startTime: json['time_from'], 
      endTime: json['time_to'], 
      status: json['status'], 
      reason: json['reason'], 
      duration: json['duration'],
      submitDate: '${getMonthName(reqDate.month)} ${reqDate.day.toString().padLeft(2, '0')}, ${reqDate.year}',
    );
  }
}