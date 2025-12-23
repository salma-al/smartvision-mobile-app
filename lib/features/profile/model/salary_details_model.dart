class SalaryDetailsModel {
  final List<PaymentsModel> earnings, deductions;
  final String grossPay, netPay;
  final DateTime payDate;

  SalaryDetailsModel({
    required this.earnings, 
    required this.deductions, 
    required this.grossPay,
    required this.netPay,
    required this.payDate,
  });

  factory SalaryDetailsModel.fromJson(Map<String, dynamic> json) {
    return SalaryDetailsModel(
      earnings: json['earnings'] == null ? [] : List<PaymentsModel>.from(json['earnings'].map((e) => PaymentsModel.fromJson(e))),
      deductions: json['deductions'] == null ? [] : List<PaymentsModel>.from(json['deductions'].map((e) => PaymentsModel.fromJson(e))),
      grossPay: '£${json['gross_pay']}',
      netPay: '£${json['net_pay']}',
      payDate: (json['posting_date'] != null) ? DateTime.tryParse(json['posting_date'] ?? 'not set') ?? DateTime.now() : DateTime.now(),
    );
  }
}

class PaymentsModel {
  final String type, value;

  PaymentsModel({required this.type, required this.value});

  factory PaymentsModel.fromJson(Map json) {
    return PaymentsModel(type: json['salary_component'], value: '£${json['amount']}');
  }
}