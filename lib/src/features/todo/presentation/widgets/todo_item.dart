import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/todo.dart';
import '../providers/todo_provider.dart';

class TodoItem extends ConsumerStatefulWidget {
  final Todo todo;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const TodoItem({
    super.key,
    required this.todo,
    this.onToggle,
    this.onDelete,
  });

  @override
  ConsumerState<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends ConsumerState<TodoItem> {
  bool _isDeleting = false;

  Future<void> _handleDismiss() async {
    if (_isDeleting) return;
    setState(() => _isDeleting = true);
    
    final success = await ref.read(todoProvider.notifier).removeTodo(widget.todo);
    
    if (success && mounted) {
      widget.onDelete?.call();
    } else if (mounted) {
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete todo'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isDeleting) {
      return const SizedBox.shrink();
    }

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
      onDismissed: (_) => _handleDismiss(),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: widget.todo.group.color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          onTap: widget.onToggle,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CheckBox(
                  isDone: widget.todo.isDone,
                  color: widget.todo.group.color,
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
                          decoration: widget.todo.isDone ? TextDecoration.lineThrough : null,
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
                              color: widget.todo.group.color.withOpacity(0.1),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.todo.dueDate != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDate(widget.todo.dueDate!),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
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
                  itemBuilder: (context) => Priority.values
                      .map(
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
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
