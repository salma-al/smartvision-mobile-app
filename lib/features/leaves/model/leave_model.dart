class LeaveModel {
  final String createDate, fromDate, endDate, status, type, reason;

  LeaveModel({
    required this.createDate, 
    required this.fromDate, 
    required this.endDate, 
    required this.status, 
    required this.type, 
    required this.reason,
  });

  factory LeaveModel.fromJson(Map json) {
    return LeaveModel(
      createDate: json['posting_date'], 
      fromDate: json['from_date'], 
      endDate: json['to_date'], 
      status: json['status'], 
      type: json['leave_type'], 
      reason: json['description'] ?? '',
    );
  }
}