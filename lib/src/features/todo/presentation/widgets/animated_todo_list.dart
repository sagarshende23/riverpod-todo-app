import 'package:flutter/material.dart';
import '../../domain/models/todo.dart';
import 'animated_todo_item.dart';

class AnimatedTodoList extends StatefulWidget {
  final List<Todo> todos;
  final Function(Todo) onTodoTap;
  final Function(Todo)? onTodoLongPress;

  const AnimatedTodoList({
    Key? key,
    required this.todos,
    required this.onTodoTap,
    this.onTodoLongPress,
  }) : super(key: key);

  @override
  State<AnimatedTodoList> createState() => _AnimatedTodoListState();
}

class _AnimatedTodoListState extends State<AnimatedTodoList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Todo> _todos;
  Todo? _selectedTodo;

  @override
  void initState() {
    super.initState();
    _todos = List.from(widget.todos);
  }

  @override
  void didUpdateWidget(AnimatedTodoList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todos != oldWidget.todos) {
      final newTodos = widget.todos;
      
      // Handle removals
      for (var oldTodo in _todos) {
        if (!newTodos.contains(oldTodo)) {
          final index = _todos.indexOf(oldTodo);
          _todos.removeAt(index);
          _listKey.currentState?.removeItem(
            index,
            (context, animation) => _buildItem(oldTodo, animation),
            duration: const Duration(milliseconds: 300),
          );
        }
      }

      // Handle additions
      for (var newTodo in newTodos) {
        if (!_todos.contains(newTodo)) {
          final insertIndex = newTodos.indexOf(newTodo);
          _todos.insert(insertIndex, newTodo);
          _listKey.currentState?.insertItem(
            insertIndex,
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _todos.length,
      itemBuilder: (context, index, animation) {
        return _buildItem(_todos[index], animation);
      },
    );
  }

  Widget _buildItem(Todo todo, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
      ),
      child: FadeTransition(
        opacity: animation,
        child: AnimatedTodoItem(
          key: ValueKey(todo.key),
          todo: todo,
          isSelected: todo == _selectedTodo,
          onTap: () {
            setState(() {
              _selectedTodo = todo;
            });
            widget.onTodoTap(todo);
          },
          onLongPress: widget.onTodoLongPress != null
              ? () => widget.onTodoLongPress!(todo)
              : null,
        ),
      ),
    );
  }
}
