import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/common/theme/app_theme.dart';
import 'src/common/providers/theme_provider.dart';
import 'src/features/todo/domain/models/todo.dart';
import 'src/features/todo/presentation/screens/home_screen.dart';
import 'src/features/user/domain/providers/user_provider.dart';
import 'src/features/user/presentation/widgets/user_name_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters with correct type IDs
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(PriorityAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(TaskGroupTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TodoAdapter());
  }

  // Clear existing boxes (temporary fix)
  await Hive.deleteBoxFromDisk('todos');
  await Hive.deleteBoxFromDisk('user_settings');
  await Hive.deleteBoxFromDisk('settings');

  // Open Hive boxes
  await Hive.openBox<Todo>('todos');
  await Hive.openBox('user_settings');
  await Hive.openBox<bool>('settings');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final userState = ref.watch(userProvider);
    final userName = userState.userName;

    return MaterialApp(
      title: userName != null ? 'Welcome, $userName' : 'Todo App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AppHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppHome extends ConsumerStatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  ConsumerState<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends ConsumerState<AppHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunch();
    });
  }

  Future<void> _checkFirstLaunch() async {
    final userState = ref.read(userProvider);
    if (userState.isFirstLaunch) {
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const UserNameDialog(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
