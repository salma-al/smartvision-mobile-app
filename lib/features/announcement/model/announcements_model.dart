class AnnouncementsModel {
  final String name, description, date;

  AnnouncementsModel({required this.name, required this.description, required this.date});

  factory AnnouncementsModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementsModel(
      name: json['name'],
      description: json['body_mail'],
      date: json['date'],
    );
  }
}