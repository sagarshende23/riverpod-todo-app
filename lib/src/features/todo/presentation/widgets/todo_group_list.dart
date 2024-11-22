import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/todo.dart';
import '../providers/todo_provider.dart';
import 'todo_item.dart';

class TodoGroupList extends ConsumerWidget {
  final TaskGroupType groupType;

  const TodoGroupList({
    Key? key,
    required this.groupType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupTodos =
        ref.watch(todoProvider.notifier).getTodosByGroup(groupType, completed: null);
    final group = TaskGroup.getByType(groupType);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: groupTodos.isEmpty
          ? Center(
              key: ValueKey('empty-${group.type}'),
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
            )
          : ListView.builder(
              key: ValueKey('list-${group.type}'),
              itemCount: groupTodos.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final todo = groupTodos[index];
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
                    final success =
                        await ref.read(todoProvider.notifier).removeTodo(todo);
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
                            final newTodo =
                                await ref.read(todoProvider.notifier).addTodo(
                                      todo.title,
                                      groupType.index,
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
                      final success = await ref
                          .read(todoProvider.notifier)
                          .toggleTodo(todo);
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
              },
            ),
    );
  }
}
