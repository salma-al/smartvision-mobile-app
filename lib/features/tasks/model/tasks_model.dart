class TaskModel {
  final String id;
  final String title;
  final String description;
  final String projectName;
  final String date;
  String status; // 'Pending', 'In Progress', 'Completed', 'Cancelled'
  final String? dueDate;
  final String? assignedBy;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.projectName,
    required this.date,
    required this.status,
    this.dueDate,
    this.assignedBy,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      projectName: json['project_name'] ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? 'Pending',
      dueDate: json['due_date'],
      assignedBy: json['assigned_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'project_name': projectName,
      'date': date,
      'status': status,
      'due_date': dueDate,
      'assigned_by': assignedBy,
    };
  }
}

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String startDate;
  final String? endDate;
  final String status; // 'Active', 'Completed', 'On Hold'
  final int tasksCount;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.tasksCount,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'],
      status: json['status'] ?? 'Active',
      tasksCount: json['tasks_count'] ?? 0,
    );
  }
}