class RequestModel {
  final String id, employeeName, docType, requestType, startDate;
  String status;
  final String? reason, endDate, duration;
  bool showActions = false;

  RequestModel({
    required this.id,
    required this.employeeName,
    required this.docType,
    required this.requestType,
    required this.status,
    required this.startDate,
    this.endDate,
    this.reason,
    this.duration,
    this.showActions = false,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json, bool show) {
    return RequestModel(
      id: json['name'] ?? '',
      employeeName: json['employee_name'] ?? '',
      docType: json['doctype']?? '',
      requestType: json['request_type'] ?? json['doctype'] ?? '',
      status: json['status'] ?? '',
      startDate: json['from_date'] ?? '',
      endDate: json['to_date'],
      reason: json['reason']?? '',
      duration: json['duration']?.toString(),
      showActions: show,
    );
  }
}