import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'deadline_status.dart';

part 'todo.g.dart';

@HiveType(typeId: 2)
enum Priority {
  @HiveField(0)
  high,
  @HiveField(1)
  medium,
  @HiveField(2)
  low;

  Color get color {
    switch (this) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  String get label {
    return name[0].toUpperCase() + name.substring(1);
  }

  IconData get icon => Icons.flag;
}

@HiveType(typeId: 1)
enum TaskGroupType {
  @HiveField(0)
  today,
  @HiveField(1)
  tomorrow,
  @HiveField(2)
  important,
}

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  int groupIndex;

  @HiveField(3)
  Priority priority;

  Todo({
    required this.title,
    this.isDone = false,
    this.groupIndex = 0,
    this.priority = Priority.medium,
  });

  TaskGroup get group => TaskGroup.values[groupIndex];

  Future<void> toggle() async {
    isDone = !isDone;
    await save();
  }

  Future<void> updateTitle(String newTitle) async {
    title = newTitle;
    await save();
  }

  Future<void> updateGroup(TaskGroupType newGroup) async {
    groupIndex = newGroup.index;
    await save();
  }

  Future<void> updatePriority(Priority newPriority) async {
    priority = newPriority;
    await save();
  }

  Todo copyWith({
    String? title,
    bool? isDone,
    int? groupIndex,
    Priority? priority,
  }) {
    return Todo(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      groupIndex: groupIndex ?? this.groupIndex,
      priority: priority ?? this.priority,
    );
  }
}

class TaskGroup {
  final String label;
  final Color color;
  final IconData icon;
  final TaskGroupType type;

  const TaskGroup._({
    required this.label,
    required this.color,
    required this.icon,
    required this.type,
  });

  static const values = [
    TaskGroup._(
      label: 'Today',
      color: Colors.blue,
      icon: Icons.today,
      type: TaskGroupType.today,
    ),
    TaskGroup._(
      label: 'Tomorrow',
      color: Colors.purple,
      icon: Icons.event,
      type: TaskGroupType.tomorrow,
    ),
    TaskGroup._(
      label: 'Important',
      color: Colors.red,
      icon: Icons.star,
      type: TaskGroupType.important,
    ),
  ];

  static TaskGroup getByType(TaskGroupType type) {
    return values.firstWhere((group) => group.type == type);
  }

  static TaskGroup getByIndex(int index) {
    return values[index];
  }
}
