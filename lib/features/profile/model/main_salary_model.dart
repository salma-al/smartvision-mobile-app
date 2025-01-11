class MainSalaryModel {
  final String id, month;

  MainSalaryModel({required this.id, required this.month});

  factory MainSalaryModel.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.tryParse(json['end_date']) ?? DateTime.now();
    return MainSalaryModel(
      id: json['name'], 
      month: getMonthStrOfDate(date),
    );
  }
}

String getMonthStrOfDate(DateTime date) {
  int month = date.month;
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}