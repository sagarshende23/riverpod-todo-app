import 'package:flutter/material.dart';
import '../../domain/models/todo.dart';

class AnimatedTodoItem extends StatefulWidget {
  final Todo todo;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;

  const AnimatedTodoItem({
    Key? key,
    required this.todo,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<AnimatedTodoItem> createState() => _AnimatedTodoItemState();
}

class _AnimatedTodoItemState extends State<AnimatedTodoItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSelected) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.todo.priority.color.withOpacity(0.2),
                        border: Border.all(
                          color: widget.todo.priority.color,
                          width: 2.0,
                        ),
                      ),
                      child: widget.todo.isDone
                          ? Icon(
                              Icons.check,
                              size: 16.0,
                              color: widget.todo.priority.color,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.todo.title,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              decoration: widget.todo.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: widget.todo.isDone
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color
                                      ?.withOpacity(0.6)
                                  : Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                          if (widget.todo.dueDate != null) ...[
                            const SizedBox(height: 4.0),
                            Text(
                              'Due: ${_formatDate(widget.todo.dueDate!)}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.color
                                    ?.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Icon(
                      widget.todo.priority.icon,
                      color: widget.todo.priority.color,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
