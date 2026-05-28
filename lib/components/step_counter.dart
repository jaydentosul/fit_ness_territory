import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class StepCounter {
  int _stepsAtStart = 0;
  int _currentSteps = 0;
  StreamSubscription<StepCount>? _stepSubscription;

  int get steps => _currentSteps;

  Future<bool> start(void Function(int) onStep) async {
    //request activity recognition permission on android
    final status = await Permission.activityRecognition.request();
    if (status.isDenied || status.isPermanentlyDenied) return false;

    await _stepSubscription?.cancel();
    _stepsAtStart = 0;
    _currentSteps = 0;

    _stepSubscription = Pedometer.stepCountStream.listen((StepCount event) {
        if (_stepsAtStart == 0 && event.steps > 0) {
          _stepsAtStart = event.steps;  //captures the step from the pedometer
        }
        _currentSteps = (event.steps - _stepsAtStart).clamp(0, 999999);
        onStep(_currentSteps);
      },
      onError: (_) {},  //if sensor unavailable -> steps zero
      cancelOnError: false
    ) as StreamSubscription<StepCount>?;

    return true;
  }

  void pause() {
    _stepSubscription?.pause();
  }

  void resume(void Function(int) onStep) {
    if (_stepSubscription?.isPaused ?? false) {
      _stepSubscription?.resume();
    }
  }

  void stop() {
    _stepSubscription?.cancel();
    _stepSubscription = null;
  }

  void reset() {
    stop();
    _stepsAtStart = 0;
    _currentSteps = 0;
  }

}