class LeaveRequestsModel {
  final String postingDate, fromDate, toDate, status, type, description;

  LeaveRequestsModel({
    required this.postingDate, 
    required this.fromDate, 
    required this.toDate, 
    required this.status, 
    required this.type, 
    required this.description,
  });

  factory LeaveRequestsModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestsModel(
      postingDate: json['posting_date'], 
      fromDate: json['from_date'], 
      toDate: json['to_date'], 
      status: json['status'], 
      type: json['leave_type'], 
      description: json['description'] ?? '',
    );
  }
}

class ShiftRequestsModel {
  final String type, fromDate, toDate;
  String status;

  ShiftRequestsModel({required this.type, required this.status, required this.fromDate, required this.toDate});

  factory ShiftRequestsModel.fromJson(Map<String, dynamic> json) {
    return ShiftRequestsModel(
      type: json['shift_type'], 
      status: json['status'], 
      fromDate: json['from_date'], 
      toDate: json['to_date'],
    );
  }
}