import 'dart:async';
import '../services/run_service.dart';

class RunTimer {
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;

  // getter for current elapsed time
  Duration get elapsed => _elapsedTime;

  //simple calories estimation (approx 8cal/min jogging)
  double get calories => _elapsedTime.inSeconds / 60 * 8;

  // start the timer
  void start(void Function(Duration) onTick) {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTime += const Duration(seconds: 1);
      onTick(_elapsedTime);
    });
  }

  // pause the timer
  void pause() {
    _timer?.cancel();
  }

  // reset timer back to 0
  void reset() {
    _timer?.cancel();
    _elapsedTime = Duration.zero;
  }

  // save run to Firebase
  // also can later include map/territory info here too?
  Future<void> saveRun() async {
    int seconds = _elapsedTime.inSeconds;

    await RunService().saveRun(seconds);
  }
}