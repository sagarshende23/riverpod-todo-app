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
    final currentGroup = TaskGroup.values[_currentIndex];

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: TaskGroup.values.map((group) {
            return Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(group.icon, color: group.color),
                  const SizedBox(width: 8),
                  Text(
                    group.name,
                    style: TextStyle(color: group.color),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: TaskGroup.values.map((group) {
              final groupTodos = ref
                  .read(todoProvider.notifier)
                  .getTodosByGroup(group.type);

              return groupTodos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            group.icon,
                            size: 48,
                            color: group.color.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tasks in ${group.name}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: groupTodos.length,
                      itemBuilder: (context, index) {
                        final todo = groupTodos[index];
                        return Dismissible(
                          key: ValueKey(todo.key),
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
                          onDismissed: (_) {
                            ref.read(todoProvider.notifier).removeTodo(todo);
                          },
                          child: TodoItem(
                            todo: todo,
                            onToggle: () {
                              ref.read(todoProvider.notifier).toggleTodo(todo);
                            },
                          ),
                        );
                      },
                    );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
