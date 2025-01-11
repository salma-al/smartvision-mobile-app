class SalaryDetailsModel {
  final String bankName, bankAccountNo, grossAmount, netAmount;
  final List<SalarySubList> deductionList, earningList;

  SalaryDetailsModel({
    required this.bankName, 
    required this.bankAccountNo, 
    required this.grossAmount, 
    required this.netAmount, 
    required this.deductionList, 
    required this.earningList,
  });

  factory SalaryDetailsModel.fromJson(Map<String, dynamic> json) {
    return SalaryDetailsModel(
      bankName: json['bank_name'] ?? 'not set',
      bankAccountNo: json['bank_account_no'] ?? 'not set',
      grossAmount: json['gross_pay'].toString(),
      netAmount: json['net_pay'].toString(),
      deductionList: List<SalarySubList>.from(json['deductions'].map((x) => SalarySubList.fromJson(x))),
      earningList: List<SalarySubList>.from(json['earnings'].map((x) => SalarySubList.fromJson(x))),
    );
  }
}

class SalarySubList {
  final String name, amount;

  SalarySubList({required this.name, required this.amount});

  factory SalarySubList.fromJson(Map<String, dynamic> json) {
    return SalarySubList(
      name: json['salary_component'],
      amount: json['amount'].toString(),
    );
  }
}