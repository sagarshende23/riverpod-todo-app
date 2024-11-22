import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/todo.dart';
import '../providers/todo_provider.dart';
import 'todo_item.dart';

class TodoList extends ConsumerStatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  ConsumerState<TodoList> createState() => _TodoListState();
}

class _TodoListState extends ConsumerState<TodoList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TaskGroup.values.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(todoProvider);
    final sortType = ref.watch(todoSortProvider);
    final currentGroup = TaskGroup.values[_currentIndex];

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: TaskGroup.values.map((group) {
            final todos = ref
                .watch(todoProvider.notifier)
                .getSortedTodos(group.type, sortType);
            final activeTodos = todos.where((todo) => !todo.isDone).toList();

            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(group.icon),
                  const SizedBox(width: 8),
                  Text(group.label),
                  if (activeTodos.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: group.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        activeTodos.length.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: group.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tasks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              PopupMenuButton<TodoSort>(
                icon: const Icon(Icons.sort),
                onSelected: (TodoSort value) {
                  ref.read(todoSortProvider.notifier).state = value;
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: TodoSort.priority,
                    child: Text('Sort by Priority'),
                  ),
                  const PopupMenuItem(
                    value: TodoSort.dueDate,
                    child: Text('Sort by Due Date'),
                  ),
                  const PopupMenuItem(
                    value: TodoSort.createdAt,
                    child: Text('Sort by Creation Date'),
                  ),
                  const PopupMenuItem(
                    value: TodoSort.alphabetical,
                    child: Text('Sort Alphabetically'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: TaskGroup.values.map((group) {
              final todos = ref
                  .watch(todoProvider.notifier)
                  .getSortedTodos(group.type, sortType);
              
              final activeTodos = todos.where((todo) => !todo.isDone).toList();
              final completedTodos = todos.where((todo) => todo.isDone).toList();

              if (activeTodos.isEmpty && completedTodos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        group.icon,
                        size: 64,
                        color: group.color.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks in ${group.label}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.5),
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (activeTodos.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 8),
                      child: Text(
                        'Active',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...activeTodos.map((todo) => _buildTodoItem(todo)),
                  ],
                  if (completedTodos.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                        top: activeTodos.isNotEmpty ? 16 : 0,
                        bottom: 8,
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ...completedTodos.map((todo) => _buildTodoItem(todo)),
                  ],
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTodoItem(Todo todo) {
    return Dismissible(
      key: ValueKey(todo.key ?? todo.title),
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
      onDismissed: (_) async {
        final success = await ref.read(todoProvider.notifier).removeTodo(todo);
        if (!success) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete task'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${todo.title}" deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                final newTodo = await ref.read(todoProvider.notifier).addTodo(
                      todo.title,
                      todo.groupIndex,
                      priority: todo.priority,
                    );
                if (newTodo == null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to restore task'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
      child: TodoItem(
        todo: todo,
        onToggle: () async {
          final success = await ref.read(todoProvider.notifier).toggleTodo(todo);
          if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to update task'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}
