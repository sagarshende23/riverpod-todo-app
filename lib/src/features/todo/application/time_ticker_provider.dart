import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeTickerProvider =
    StateNotifierProvider<TimeTickerNotifier, DateTime>((ref) {
  return TimeTickerNotifier();
});

class TimeTickerNotifier extends StateNotifier<DateTime> {
  Timer? _timer;

  TimeTickerNotifier() : super(DateTime.now()) {
    // Update every 30 seconds for more accurate time tracking
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      state = DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
