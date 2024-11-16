import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  bool isDone;

  @HiveField(2)
  final int groupIndex;

  @HiveField(3)
  final DateTime createdAt;

  Todo({
    required this.title,
    this.isDone = false,
    required this.groupIndex,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TaskGroup get group => TaskGroup.values[groupIndex];

  Todo copyWith({
    String? title,
    bool? isDone,
    int? groupIndex,
    DateTime? createdAt,
  }) {
    return Todo(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      groupIndex: groupIndex ?? this.groupIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@HiveType(typeId: 1)
enum TaskGroupType {
  @HiveField(0)
  today,
  @HiveField(1)
  tomorrow,
  @HiveField(2)
  important,
  @HiveField(3)
  notImportant,
}

class TaskGroup {
  final String name;
  final IconData icon;
  final Color color;
  final TaskGroupType type;

  const TaskGroup._({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  static const List<TaskGroup> values = [
    TaskGroup._(
      name: 'Today',
      icon: Icons.today,
      color: Colors.blue,
      type: TaskGroupType.today,
    ),
    TaskGroup._(
      name: 'Tomorrow',
      icon: Icons.calendar_today,
      color: Colors.orange,
      type: TaskGroupType.tomorrow,
    ),
    TaskGroup._(
      name: 'Important',
      icon: Icons.star,
      color: Colors.red,
      type: TaskGroupType.important,
    ),
    TaskGroup._(
      name: 'Not Important',
      icon: Icons.low_priority,
      color: Colors.green,
      type: TaskGroupType.notImportant,
    ),
  ];

  static TaskGroup getByType(TaskGroupType type) {
    return values.firstWhere((group) => group.type == type);
  }

  static TaskGroup getByIndex(int index) {
    return values[index];
  }
}
