import 'package:smart_vision/core/helper/shared_functions.dart';

class ShiftModel {
  final String type, status, from, to, reason, submitDate;

  ShiftModel({
    required this.type, 
    required this.status, 
    required this.from, 
    required this.to, 
    required this.reason,
    required this.submitDate,
  });

  factory ShiftModel.fromJson(Map json) {
    DateTime submit = DateTime.tryParse(json['creation'] ?? '') ?? DateTime.now();
    DateTime from = DateTime.tryParse(json['from_date'] ?? '') ?? DateTime.now();
    DateTime to = DateTime.tryParse(json['to_date'] ?? '') ?? DateTime.now();
    return ShiftModel(
      type: json['shift_type'], 
      status: json['status'], 
      from: '${getMonthName(from.month)} ${from.day.toString().padLeft(2, '0')}', 
      to: '${getMonthName(to.month)} ${to.day.toString().padLeft(2, '0')}',
      reason: json['reason'] ?? '',
      submitDate: '${getMonthName(submit.month)} ${submit.day.toString().padLeft(2, '0')}, ${submit.year}',
    );
  }
}