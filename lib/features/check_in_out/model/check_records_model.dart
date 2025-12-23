class CheckModel {
  final String startTime, endTime, totalShift, breakTime;
  final bool requiredImage, availableCheck;
  final List<CheckRecordsModel> records;

  CheckModel({
    required this.startTime,
    required this.endTime,
    required this.totalShift,
    required this.breakTime,
    required this.requiredImage,
    required this.availableCheck,
    required this.records,
  });

  factory CheckModel.fromJson(Map<String, dynamic> json) {
    final shift = json['shift'] ?? {};

    String rawStart = shift['start_time'] ?? '00:00:00';
    String rawEnd   = shift['end_time'] ?? '00:00:00';

    // Convert to 12h format
    String formattedStart = formatTo12Hour(rawStart);
    String formattedEnd   = formatTo12Hour(rawEnd);

    // parse for total shift
    List<String> startParts = rawStart.split(':');
    List<String> endParts   = rawEnd.split(':');

    int startH = int.tryParse(startParts[0]) ?? 0;
    int startM = int.tryParse(startParts[1]) ?? 0;

    int endH = int.tryParse(endParts[0]) ?? 0;
    int endM = int.tryParse(endParts[1]) ?? 0;

    DateTime start = DateTime(2026, 1, 1, startH, startM);
    DateTime end = DateTime(2026, 1, 1, endH, endM);

    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    int diff = end.difference(start).inMinutes;

    String totalShift =
        '${(diff ~/ 60).toString().padLeft(2, '0')}:'
        '${(diff % 60).toString().padLeft(2, '0')}:00';

    return CheckModel(
      startTime: formattedStart,
      endTime: formattedEnd,
      totalShift: totalShift,
      breakTime: "1 PM - 2 PM",
      requiredImage: (json['company_details'] ?? {})['log_with_image'] ?? false,
      availableCheck: json['shift status'] ?? false,
      records: (json['checkins'] as List<dynamic>? ?? [])
          .map((e) => CheckRecordsModel.fromJson(e))
          .toList(),
    );
  }
}

class CheckRecordsModel {
  String checkInTime, checkOutTime;

  CheckRecordsModel({required this.checkInTime, required this.checkOutTime});

  factory CheckRecordsModel.fromJson(Map<String, dynamic> json) {
    return CheckRecordsModel(
      checkInTime: json['check_in'] ?? '---',
      checkOutTime: json['check_out'] ?? '---',
    );
  }
}

String formatTo12Hour(String time) {
  // time = "09:00:00"
  List<String> parts = time.split(':');

  int hour = int.tryParse(parts[0]) ?? 0;
  int minute = int.tryParse(parts[1]) ?? 0;

  final dt = DateTime(2026, 1, 1, hour, minute);

  String suffix = dt.hour >= 12 ? "PM" : "AM";
  int hour12 = dt.hour % 12;
  hour12 = hour12 == 0 ? 12 : hour12;

  return "$hour12$suffix"; // Example: 9AM
}
