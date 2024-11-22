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

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? dueDate;

  Todo({
    required this.title,
    this.isDone = false,
    required this.groupIndex,
    this.priority = Priority.medium,
    DateTime? createdAt,
    this.dueDate,
  }) : createdAt = createdAt ?? DateTime.now();

  TaskGroup get group => TaskGroup.values[groupIndex];

  bool get isOverdue {
    if (dueDate == null || isDone) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  DeadlineStatus get deadlineStatus {
    if (isDone) return DeadlineStatus.none;
    if (dueDate == null) return DeadlineStatus.none;
    
    if (isOverdue) return DeadlineStatus.overdue;
    
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    
    if (difference.inHours <= 24) return DeadlineStatus.urgent;
    if (difference.inDays <= 3) return DeadlineStatus.upcoming;
    return DeadlineStatus.scheduled;
  }

  String get dueDateFormatted {
    if (dueDate == null) return 'No due date';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDay = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    
    String timeStr = '${dueDate!.hour.toString().padLeft(2, '0')}:${dueDate!.minute.toString().padLeft(2, '0')}';
    
    if (dueDay == today) {
      return 'Today at $timeStr';
    } else if (dueDay == tomorrow) {
      return 'Tomorrow at $timeStr';
    } else {
      return '${dueDay.day}/${dueDay.month}/${dueDay.year} at $timeStr';
    }
  }

  String get timeRemaining {
    if (dueDate == null) return '';
    
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    
    if (difference.isNegative) {
      final duration = difference.abs();
      if (duration.inDays > 0) return '${duration.inDays}d overdue';
      if (duration.inHours > 0) return '${duration.inHours}h overdue';
      if (duration.inMinutes > 0) return '${duration.inMinutes}m overdue';
      return 'Just overdue';
    }
    
    if (difference.inDays > 0) return 'In ${difference.inDays}d';
    if (difference.inHours > 0) return 'In ${difference.inHours}h';
    if (difference.inMinutes > 0) return 'In ${difference.inMinutes}m';
    return 'Due now';
  }

  String get deadlineMessage {
    if (dueDate == null) return '';
    if (isDone) return 'COMPLETED';
    if (isOverdue) return 'OVERDUE';
    
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    
    if (difference.inHours <= 24) return 'DUE SOON';
    if (difference.inDays <= 3) return 'UPCOMING';
    return 'SCHEDULED';
  }

  Color get dueDateColor {
    if (isDone) return Colors.grey;
    if (isOverdue) return Colors.red.shade700;
    if (dueDate == null) return Colors.grey;
    
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    
    if (difference.inHours <= 24) return Colors.orange.shade700;
    if (difference.inDays <= 3) return Colors.amber.shade700;
    return Colors.blue.shade700;
  }

  IconData get deadlineIcon {
    if (isDone) return Icons.check_circle_outline;
    if (isOverdue) return Icons.warning_rounded;
    if (dueDate == null) return Icons.calendar_today_outlined;
    
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    
    if (difference.inHours <= 24) return Icons.timer;
    if (difference.inDays <= 3) return Icons.upcoming;
    return Icons.event;
  }

  Future<void> setDueDate(DateTime? newDueDate) async {
    dueDate = newDueDate;
    await save();  // Save changes to Hive
  }

  Future<void> removeDueDate() async {
    dueDate = null;
    await save();  // Save changes to Hive
  }

  Future<void> updateDueDate(DateTime? dateTime) async {
    final box = await Hive.openBox<Todo>('todos');
    final todo = box.get(key);
    if (todo != null) {
      todo.dueDate = dateTime;
      await todo.save();
    }
  }

  Future<void> removeDueDateNew() async {
    await updateDueDate(null);
  }

  Todo copyWith({
    String? title,
    bool? isDone,
    int? groupIndex,
    Priority? priority,
    DateTime? dueDate,
  }) {
    return Todo(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      groupIndex: groupIndex ?? this.groupIndex,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
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
