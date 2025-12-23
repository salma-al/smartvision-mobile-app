import '../../../core/helper/shared_functions.dart';

class MainSalaryModel {
  final List<SingleSalaryModel> salaries;

  MainSalaryModel({required this.salaries});

  factory MainSalaryModel.fromJson(Map<String, dynamic> json) {
    return MainSalaryModel(
      salaries: List<SingleSalaryModel>.from((json['salaries'] as List).map((e) => SingleSalaryModel.fromJson(e))), 
    );
  }
}

class SingleSalaryModel {
  final String id, month, netPay;
  final bool isLatest;

  SingleSalaryModel({
    required this.id, 
    required this.month,
    required this.netPay,
    required this.isLatest
  });

  factory SingleSalaryModel.fromJson(Map<String, dynamic> json) {
    DateTime curr = DateTime.now();
    DateTime date = DateTime.tryParse(json['end_date']) ?? curr;
    return SingleSalaryModel(
      id: json['name'], 
      month: '${getFullMonthName(date.month)} ${date.year}',
      netPay: '£${json['net_pay']}',
      isLatest: curr.month == date.month,
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