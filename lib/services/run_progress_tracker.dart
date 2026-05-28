import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunProgressTracker {
  bool _isRunning = false;
  double _totalDistanceMetres = 0.0;
  LatLng? _lastPosition;

  bool get isRunning => _isRunning;
  double get totalDistanceMetres => _totalDistanceMetres;

  void startRun() {
    _isRunning = true;
    _totalDistanceMetres = 0.0;
    _lastPosition = null;
  }

  void pauseRun() {
    _isRunning = false;
  }

  void resumeRun() {
    _isRunning = true;
  }

  void stopRun() {
    _isRunning = false;
    _totalDistanceMetres = 0.0;
    _lastPosition = null;
  }

  void updatePosition(LatLng newPosition) {
    if (!_isRunning) {
      return;
    }

    if (_lastPosition == null) {
      _lastPosition = newPosition;
      return;
    }

    final double addedDistance = Geolocator.distanceBetween(
      _lastPosition!.latitude,
      _lastPosition!.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );

    if (addedDistance >= 1.0) {
      _totalDistanceMetres += addedDistance;
    }

    _lastPosition = newPosition;
  }

  String formatDistance(double metres) {
    if (metres < 1000) {
      return '${metres.toStringAsFixed(0)} m';
    }

    final double kilometres = metres / 1000;

    return '${kilometres.toStringAsFixed(2)} km';
  }
}