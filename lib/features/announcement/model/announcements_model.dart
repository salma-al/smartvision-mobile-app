import 'package:smart_vision/core/helper/http_helper.dart';

class AnnouncementsModel {
  final String name, description, date, tag;
  final bool isNew;
  final List<String> attachments;

  AnnouncementsModel({
    required this.name, 
    required this.description, 
    required this.date, 
    required this.isNew, 
    required this.tag, 
    required this.attachments});

  factory AnnouncementsModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementsModel(
      name: json['name'],
      description: json['body_mail'],
      date: json['date'],
      isNew: json['isNew'] ?? false,
      tag: json['tag'] ?? '',
      attachments: json['attachments'] != null ? List<String>.from(json['attachments'].map((file) => '${HTTPHelper.fileBaseUrl}$file')) : [],
    );
  }
}