import 'package:flutter/material.dart';

enum DeadlineStatus {
  overdue, // Past due date
  urgent, // Due within 24 hours
  upcoming, // Due within 3 days
  scheduled, // Has future due date
  none; // No due date set

  String get message {
    switch (this) {
      case DeadlineStatus.overdue:
        return 'OVERDUE';
      case DeadlineStatus.urgent:
        return 'DUE SOON';
      case DeadlineStatus.upcoming:
        return 'UPCOMING';
      case DeadlineStatus.scheduled:
        return 'SCHEDULED';
      case DeadlineStatus.none:
        return 'NO DUE DATE';
    }
  }

  Color get color {
    switch (this) {
      case DeadlineStatus.overdue:
        return Colors.red;
      case DeadlineStatus.urgent:
        return Colors.orange;
      case DeadlineStatus.upcoming:
        return Colors.amber;
      case DeadlineStatus.scheduled:
        return Colors.blue;
      case DeadlineStatus.none:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case DeadlineStatus.overdue:
        return Icons.warning_rounded;
      case DeadlineStatus.urgent:
        return Icons.timer;
      case DeadlineStatus.upcoming:
        return Icons.upcoming;
      case DeadlineStatus.scheduled:
        return Icons.event;
      case DeadlineStatus.none:
        return Icons.calendar_today;
    }
  }
}

class DeadlineHandler {
  static DeadlineStatus getStatus(DateTime? dueDate, {bool isDone = false}) {
    if (isDone || dueDate == null) return DeadlineStatus.none;

    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return DeadlineStatus.overdue;
    } else if (difference.inHours <= 24) {
      return DeadlineStatus.urgent;
    } else if (difference.inDays <= 3) {
      return DeadlineStatus.upcoming;
    } else {
      return DeadlineStatus.scheduled;
    }
  }

  static String formatTimeRemaining(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      final overdue = now.difference(dueDate);
      if (overdue.inDays > 0) {
        return '${overdue.inDays}d overdue';
      } else if (overdue.inHours > 0) {
        return '${overdue.inHours}h overdue';
      } else {
        return '${overdue.inMinutes}m overdue';
      }
    } else {
      if (difference.inDays > 0) {
        return 'Due in ${difference.inDays}d';
      } else if (difference.inHours > 0) {
        return 'Due in ${difference.inHours}h';
      } else {
        return 'Due in ${difference.inMinutes}m';
      }
    }
  }

  static String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final timeStr =
        '${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')}';

    if (dueDay == today) {
      return 'Today, $timeStr';
    } else if (dueDay == tomorrow) {
      return 'Tomorrow, $timeStr';
    } else if (dueDay.difference(today).inDays < 7) {
      return '${_getWeekday(dueDay)}, $timeStr';
    } else {
      return '${dueDay.day}/${dueDay.month}/${dueDay.year}, $timeStr';
    }
  }

  static String _getWeekday(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}
