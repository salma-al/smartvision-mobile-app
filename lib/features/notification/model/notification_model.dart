class NotificationModel {
  final String name, date, title, message, docType;

  NotificationModel({required this.name, required this.date, required this.title, required this.message, required this.docType});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      name: json['name'],
      date: json['sending_date'],
      title: json['title'],
      message: json['content'],
      docType: json['doctype_name'],
    );
  }
}