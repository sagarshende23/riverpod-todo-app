import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/todo.dart';
import '../providers/todo_provider.dart';

class TodoItem extends ConsumerStatefulWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const TodoItem({
    Key? key,
    required this.todo,
    required this.onToggle,
    this.onDelete,
  }) : super(key: key);

  @override
  ConsumerState<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends ConsumerState<TodoItem> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Update every second for smooth countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isOverdue = widget.todo.dueDate != null &&
        widget.todo.dueDate!.isBefore(_now) &&
        !widget.todo.isDone;
    final bool isDueSoon = widget.todo.dueDate != null &&
        !isOverdue &&
        !widget.todo.isDone &&
        widget.todo.dueDate!.difference(_now).inHours <= 24;

    return Dismissible(
      key: ValueKey(widget.todo.key),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onDelete?.call(),
      child: Card(
        elevation: isOverdue ? 3 : 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isOverdue
                ? Colors.red.shade700
                : isDueSoon
                    ? Colors.orange
                    : widget.todo.group.color.withOpacity(0.2),
            width: isOverdue || isDueSoon ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            if (widget.todo.dueDate != null && !widget.todo.isDone)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? Colors.red
                        : isDueSoon
                            ? Colors.orange
                            : Colors.blue,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOverdue
                            ? Icons.warning
                            : isDueSoon
                                ? Icons.timer
                                : Icons.event,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getTimeRemaining(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            InkWell(
              onTap: widget.onToggle,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isOverdue
                      ? Colors.red.shade50.withOpacity(0.3)
                      : isDueSoon
                          ? Colors.orange.shade50.withOpacity(0.2)
                          : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CheckBox(
                      isDone: widget.todo.isDone,
                      color: widget.todo.isOverdue
                          ? Colors.red
                          : widget.todo.group.color,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              decoration: widget.todo.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: widget.todo.isDone ? Colors.grey : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _PriorityChip(priority: widget.todo.priority),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      widget.todo.group.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      widget.todo.group.icon,
                                      size: 16,
                                      color: widget.todo.group.color,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.todo.group.label,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: widget.todo.group.color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.todo.dueDate != null)
                                GestureDetector(
                                  onTap: () => _showDateTimePicker(context),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          _getDueDateColor().withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _getDueDateColor(),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getDeadlineIcon(),
                                          size: 16,
                                          color: _getDueDateColor(),
                                        ),
                                        const SizedBox(width: 4),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _getDeadlineMessage(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: _getDueDateColor(),
                                              ),
                                            ),
                                            Text(
                                              _getTimeRemaining(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: _getDueDateColor(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<Priority>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.grey.shade600,
                      ),
                      onSelected: (Priority priority) {
                        ref
                            .read(todoProvider.notifier)
                            .updateTodoPriority(widget.todo, priority);
                      },
                      itemBuilder: (context) => [
                        ...Priority.values.map(
                          (priority) => PopupMenuItem(
                            value: priority,
                            child: Row(
                              children: [
                                Icon(priority.icon, color: priority.color),
                                const SizedBox(width: 8),
                                Text(priority.label),
                              ],
                            ),
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Icon(
                                widget.todo.dueDate != null
                                    ? Icons.event_busy
                                    : Icons.event,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.todo.dueDate != null
                                    ? 'Change Due Date'
                                    : 'Set Due Date',
                              ),
                            ],
                          ),
                          onTap: () => _showDateTimePicker(context),
                        ),
                        if (widget.todo.dueDate != null)
                          PopupMenuItem(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  color: Colors.red.shade400,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Remove Due Date',
                                  style: TextStyle(color: Colors.red.shade400),
                                ),
                              ],
                            ),
                            onTap: () async {
                              await widget.todo.removeDueDate();
                              if (context.mounted) {
                                ref.invalidate(todoProvider);
                              }
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDeadlineMessage() {
    if (widget.todo.isDone) return 'COMPLETED';
    if (widget.todo.dueDate == null) return '';
    if (widget.todo.dueDate!.isBefore(_now)) return 'OVERDUE';

    final difference = widget.todo.dueDate!.difference(_now);
    if (difference.inHours <= 24) return 'DUE SOON';
    if (difference.inDays <= 3) return 'UPCOMING';
    return 'SCHEDULED';
  }

  String _getTimeRemaining() {
    if (widget.todo.dueDate == null) return '';

    final difference = widget.todo.dueDate!.difference(_now);
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

  Future<void> _showDateTimePicker(BuildContext context) async {
    final now = DateTime.now();
    final initialDate = widget.todo.dueDate ?? now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? initialDate : now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.todo.group.color,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && context.mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: widget.todo.group.color,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && context.mounted) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        await widget.todo.updateDueDate(dateTime);
        ref.invalidate(todoProvider);
      }
    }
  }

  Color _getDueDateColor() {
    if (widget.todo.isDone) return Colors.grey;
    if (widget.todo.dueDate == null) return Colors.grey;

    if (widget.todo.dueDate!.isBefore(_now)) return Colors.red.shade700;

    final difference = widget.todo.dueDate!.difference(_now);
    if (difference.inHours <= 24) return Colors.orange;
    if (difference.inDays <= 3) return Colors.amber;
    return Colors.blue;
  }

  IconData _getDeadlineIcon() {
    if (widget.todo.isDone) return Icons.check_circle;
    if (widget.todo.dueDate == null) return Icons.calendar_today;

    if (widget.todo.dueDate!.isBefore(_now)) return Icons.warning;

    final difference = widget.todo.dueDate!.difference(_now);
    if (difference.inHours <= 24) return Icons.timer;
    if (difference.inDays <= 3) return Icons.upcoming;
    return Icons.event;
  }
}

class _CheckBox extends StatelessWidget {
  final bool isDone;
  final Color color;

  const _CheckBox({
    Key? key,
    required this.isDone,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isDone ? color : Colors.grey.shade400,
          width: 2,
        ),
        color: isDone ? color.withOpacity(0.2) : null,
      ),
      child: isDone
          ? Icon(
              Icons.check,
              size: 16,
              color: color,
            )
          : null,
    );
  }
}

class _PriorityChip extends StatelessWidget {
  final Priority priority;

  const _PriorityChip({
    Key? key,
    required this.priority,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: priority.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            priority.icon,
            size: 16,
            color: priority.color,
          ),
          const SizedBox(width: 4),
          Text(
            priority.label,
            style: TextStyle(
              fontSize: 12,
              color: priority.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
