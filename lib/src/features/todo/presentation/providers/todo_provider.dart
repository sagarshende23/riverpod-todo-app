import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/todo.dart';

const String _todosBoxName = 'todos';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]) {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final box = await Hive.openBox<Todo>(_todosBoxName);
      state = box.values.toList();
    } catch (e) {
      state = [];
    }
  }

  Future<Todo?> addTodo(String title, int groupIndex) async {
    try {
      final box = await Hive.openBox<Todo>(_todosBoxName);
      final todo = Todo(
        title: title,
        groupIndex: groupIndex,
      );
      await box.add(todo);
      state = [...state, todo];
      return todo;
    } catch (e) {
      return null;
    }
  }

  Future<bool> toggleTodo(Todo todo) async {
    try {
      final box = await Hive.openBox<Todo>(_todosBoxName);
      todo.isDone = !todo.isDone;
      await todo.save();
      state = [...state];
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeTodo(Todo todo) async {
    try {
      final box = await Hive.openBox<Todo>(_todosBoxName);
      await todo.delete();
      state = state.where((t) => t.key != todo.key).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Todo> getTodosByGroup(TaskGroupType type) {
    return state
        .where((todo) => todo.group.type == type)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Todo? getTodoByIndex(int index) {
    if (index >= 0 && index < state.length) {
      return state[index];
    }
    return null;
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
