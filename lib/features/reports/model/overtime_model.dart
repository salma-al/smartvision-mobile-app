class OvertimeModel {
  final String name, date, startTime, endTime, status, reason;

  OvertimeModel({
    required this.name, 
    required this.date, 
    required this.startTime, 
    required this.endTime, 
    required this.status, 
    required this.reason,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic> json) {
    return OvertimeModel(
      name: json['name'], 
      date: json['day_of_overtime'], 
      startTime: json['time_from'], 
      endTime: json['time_to'], 
      status: json['status'], 
      reason: json['reason'] ?? '',
    );
  }
}