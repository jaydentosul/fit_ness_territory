import 'dart:async';

class RunTimer {
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;

  Duration get elapsed => _elapsedTime;

  void start (void Function(Duration) onTick) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime += const Duration(seconds: 1);
      onTick(_elapsedTime);
    });
  }

  void pause() {
    _timer?.cancel();
  }

  void reset() {
    _timer?.cancel();
    _elapsedTime = Duration.zero;
  }

}