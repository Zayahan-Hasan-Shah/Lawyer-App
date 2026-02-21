class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String dueDate;
  final bool isCompleted;
  final String priority;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.dueDate,
    required this.isCompleted,
    required this.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      dueDate: json['dueDate'] as String,
      isCompleted: json['isCompleted'] as bool,
      priority: json['priority'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
      'priority': priority,
    };
  }
}

class AllTasksResponse {
  final List<TaskModel> activeTasks;
  final List<TaskModel> completedTasks;

  AllTasksResponse({
    required this.activeTasks,
    required this.completedTasks,
  });
}
