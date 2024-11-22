import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/todo.dart';

const String _todosBoxName = 'todos';

final todoSortProvider = StateProvider<TodoSort>((ref) => TodoSort.priority);

enum TodoSort {
  priority,
  createdAt,
  dueDate,
  alphabetical,
}

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

  Future<Todo?> addTodo(
    String title,
    int groupIndex, {
    Priority? priority,
    DateTime? dueDate,
  }) async {
    try {
      final box = await Hive.openBox<Todo>(_todosBoxName);
      final todo = Todo(
        title: title,
        groupIndex: groupIndex,
        priority: priority ?? Priority.medium,
        dueDate: dueDate,
      );
      await box.add(todo);
      state = [...state, todo];
      return todo;
    } catch (e) {
      return null;
    }
  }

  // Future<Todo?> addTodo(String title, int groupIndex, {Priority? priority}) async {
  //   try {
  //     final box = await Hive.openBox<Todo>(_todosBoxName);
  //     final todo = Todo(
  //       title: title,
  //       groupIndex: groupIndex,
  //       priority: priority ?? Priority.medium,
  //     );
  //     await box.add(todo);
  //     state = [...state, todo];
  //     return todo;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<bool> toggleTodo(Todo todo) async {
    try {
      todo.isDone = !todo.isDone;
      await todo.save();
      state = [...state]; // Trigger a state update
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTodoPriority(Todo todo, Priority priority) async {
    try {
      todo.priority = priority;
      await todo.save();
      state = [...state]; // Trigger a state update
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTodoDueDate(Todo todo, DateTime? dueDate) async {
    try {
      todo.dueDate = dueDate;
      await todo.save();
      state = [...state]; // Trigger a state update
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeTodo(Todo todo) async {
    try {
      await todo.delete();
      state = state.where((t) => t.key != todo.key).toList();
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Todo> getTodosByGroup(TaskGroupType type, {bool? completed}) {
    return state
        .where((todo) =>
            todo.group.type == type &&
            (completed == null || todo.isDone == completed))
        .toList();
  }

  List<Todo> getSortedTodos(TaskGroupType type, TodoSort sort) {
    var todos = state.where((todo) => todo.group.type == type).toList();

    switch (sort) {
      case TodoSort.priority:
        todos.sort((a, b) {
          if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
          if (a.priority != b.priority)
            return b.priority.index.compareTo(a.priority.index);
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case TodoSort.dueDate:
        todos.sort((a, b) {
          if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
          if (a.dueDate == null && b.dueDate == null)
            return b.createdAt.compareTo(a.createdAt);
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TodoSort.createdAt:
        todos.sort((a, b) {
          if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
      case TodoSort.alphabetical:
        todos.sort((a, b) {
          if (a.isDone != b.isDone) return a.isDone ? 1 : -1;
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });
        break;
    }
    return todos;
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});
