import 'package:uuid/uuid.dart';

enum TaskStatus { todo, doing, done }

class Task {
  String id;
  String content;
  TaskStatus status;
  DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deadline;
  DateTime? completedAt;

  Task({required this.content, this.deadline})
      : createdAt = DateTime.now(),
        id = Uuid().v4(),
        status = TaskStatus.todo;

  Task.fromValues({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.status,
    this.completedAt,
    this.updatedAt,
    this.deadline,
  });

  //permet de mapper un enregistrement JSON provenant de l'API en objet Task
  factory Task.fromJSON(Map<String, dynamic> json) => Task.fromValues(
        content: json["content"],
        id: json["id"],
        status: TaskStatus.values.firstWhere(
          (v) => v.name == json["status"],
          orElse: () => TaskStatus.todo, // Valeur par défaut en cas d'erreur
        ),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.tryParse(json['updated_at']),
        completedAt: json['completedAt'] == null
            ? null
            : DateTime.tryParse(json['completed_at']),
        deadline: json['deadline'] == null
            ? null
            : DateTime.tryParse(json['deadline']),
      );

  //permet de convertir un objet Task en JSON pour l'envoyer à l'API
  Map<String, dynamic> toJSON() => {
        "id": id,
        "content": content,
        "status": status.name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "completed_at": completedAt?.toIso8601String(),
        "deadline": deadline?.toIso8601String(),
      };

  @override
  String toString() {
    return '''
    Task(
      id: $id,
      content: "$content",
      status: ${status.name},
      createdAt: ${createdAt.toIso8601String()},
      updatedAt: ${updatedAt?.toIso8601String() ?? "null"},
      completedAt: ${completedAt?.toIso8601String() ?? "null"},
      deadline: ${deadline?.toIso8601String() ?? "null"}
    )
    ''';
  }
}
