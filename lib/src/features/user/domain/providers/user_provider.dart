import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

class UserState {
  final String? userName;
  final bool isFirstLaunch;

  UserState({
    this.userName,
    this.isFirstLaunch = true,
  });

  UserState copyWith({
    String? userName,
    bool? isFirstLaunch,
  }) {
    return UserState(
      userName: userName ?? this.userName,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  static const String _boxName = 'user_settings';
  static const String _nameKey = 'user_name';
  static const String _firstLaunchKey = 'is_first_launch';

  UserNotifier() : super(UserState()) {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final box = await Hive.openBox(_boxName);
    final userName = box.get(_nameKey) as String?;
    final isFirstLaunch = box.get(_firstLaunchKey, defaultValue: true) as bool;
    
    state = UserState(
      userName: userName,
      isFirstLaunch: isFirstLaunch,
    );
  }

  Future<void> saveUserName(String name) async {
    final box = await Hive.openBox(_boxName);
    await box.put(_nameKey, name);
    await box.put(_firstLaunchKey, false);
    
    state = UserState(
      userName: name,
      isFirstLaunch: false,
    );
  }
}
