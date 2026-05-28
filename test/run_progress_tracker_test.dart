import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fit_ness_territory/services/run_progress_tracker.dart';

void main() {
  group('User Story 2: Run Progress Tracking', () {
    test('1. Distance should start at zero when a run begins', () {
      final tracker = RunProgressTracker();

      tracker.startRun();

      expect(tracker.totalDistanceMetres, 0.0);
      expect(tracker.isRunning, true);
    });

    test('2. Distance should increase when the runner moves', () {
      final tracker = RunProgressTracker();

      tracker.startRun();

      tracker.updatePosition(
        const LatLng(-36.860900, 174.776000),
      );

      tracker.updatePosition(
        const LatLng(-36.861200, 174.776300),
      );

      expect(tracker.totalDistanceMetres, greaterThan(0));
    });

    test('3. Distance should stop updating when the run is paused', () {
      final tracker = RunProgressTracker();

      tracker.startRun();

      tracker.updatePosition(
        const LatLng(-36.860900, 174.776000),
      );

      tracker.pauseRun();

      tracker.updatePosition(
        const LatLng(-36.862000, 174.777000),
      );

      expect(tracker.totalDistanceMetres, 0.0);
    });

    test('4. Distance should reset when the run is stopped', () {
      final tracker = RunProgressTracker();

      tracker.startRun();

      tracker.updatePosition(
        const LatLng(-36.860900, 174.776000),
      );

      tracker.updatePosition(
        const LatLng(-36.861200, 174.776300),
      );

      tracker.stopRun();

      expect(tracker.totalDistanceMetres, 0.0);
      expect(tracker.isRunning, false);
    });

    test('5. Distance should display in metres when under 1000 metres', () {
      final tracker = RunProgressTracker();

      final result = tracker.formatDistance(250);

      expect(result, '250 m');
    });

    test('6. Distance should display in kilometres when 1000 metres or more', () {
      final tracker = RunProgressTracker();

      final result = tracker.formatDistance(1500);

      expect(result, '1.50 km');
    });
  });
}