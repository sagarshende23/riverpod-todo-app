import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/providers/theme_provider.dart';
import '../../../feedback/presentation/widgets/feedback_dialog.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_todo_button.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FeedbackDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.feedback_outlined),
            onPressed: () => _showFeedbackDialog(context),
            tooltip: 'Send Feedback',
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const TodoList(),
      floatingActionButton: const AddTodoButton(),
    );
  }
}
