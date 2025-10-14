class AttendanceStatisticsModel {
  int present, abscent, leave, halfDay, fromHome, late, early, onTime;
  String checkIn, checkOut, totalHours;

  AttendanceStatisticsModel({
    required this.present, 
    required this.abscent, 
    required this.leave, 
    required this.halfDay, 
    required this.fromHome, 
    required this.late, 
    required this.early, 
    required this.onTime, 
    required this.totalHours, 
    required this.checkIn, 
    required this.checkOut,
  });
}