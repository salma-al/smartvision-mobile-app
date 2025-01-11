class ProjectModel {
  final int id, currentProgress;
  final String title;
  final DateTime? nextDate;

  ProjectModel({required this.id, required this.currentProgress, required this.title, required this.nextDate});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      currentProgress: json['current_progress'],
      title: json['title'],
      nextDate: DateTime.parse(json['next_date']),
    );
  }
}