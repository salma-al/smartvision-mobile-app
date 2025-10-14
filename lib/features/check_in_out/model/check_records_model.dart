class CheckRecordsModel {
  final String checkInTime, checkOutTime;

  CheckRecordsModel({required this.checkInTime, required this.checkOutTime});

  factory CheckRecordsModel.fromJson(Map<String, dynamic> json) {
    return CheckRecordsModel(
      checkInTime: json['check_in'] ?? '---',
      checkOutTime: json['check_out'] ?? '---',
    );
  }
}