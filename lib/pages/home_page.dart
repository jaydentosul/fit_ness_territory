import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_ness_territory/components/run_timer.dart';
import 'package:fit_ness_territory/modes/modes.dart';
import 'package:fit_ness_territory/services/app_settings_service.dart';
import 'package:fit_ness_territory/services/run_service.dart';
import 'package:fit_ness_territory/services/territory_sync_service.dart';
import 'package:flutter/material.dart';

import '../components/my_buttons.dart';
import '../components/my_drawer.dart';
import '../components/my_scrollable_draggable_sheet.dart';
import '../map/g_map.dart';
import '../components/step_counter.dart';


class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final GlobalKey<GMapState> _mapKey = GlobalKey<GMapState>();
  final RunTimer _runTimer = RunTimer();
  final StepCounter _stepCounter = StepCounter();

  int _steps = 0;
  double _calories = 0.0;

  double _sheetSize = 0.35;
  RunState runState = RunState.idle;
  Duration elapsed = Duration.zero;
  Duration lastRun = Duration.zero;
  double currentDistanceMetres = 0.0;
  String currentUsername = 'Loading...';

  StreamSubscription<DocumentSnapshot>? _usernameStream;

  Future<void> _startRun() async {
    if (runState == RunState.idle) {
      final bool canStartRun = await _mapKey.currentState?.prepareRunFromSelectedTerritory() ?? false;

      if (!canStartRun) {
        return;
      }

      setState(() {
        runState = RunState.running;
        elapsed = Duration.zero;
        currentDistanceMetres = 0.0;
        _calories = 0.0;
      });

      //animates the sheet when running
      _sheetController.animateTo (0.25,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      //resets and starts the timer
      _runTimer.reset();
      _runTimer.start((time) {
        setState(() {
          elapsed = time;
          });
        },
      );

      await _stepCounter.start((steps) {
        setState(() => _steps = steps);
      });
    }
  }

  //Pausing
  void _pauseRun() {
    if (runState == RunState.running) {
      _runTimer.pause();
      _stepCounter.pause();
      _mapKey.currentState?.pauseTracking();

      setState(() {
        runState = RunState.pause;
      });

      //animates the sheet when running
      _sheetController.animateTo (0.35,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

    } //Pressing play again
    else if (runState == RunState.pause) {
      _mapKey.currentState?.resumeTracking();

      setState(() {
          runState = RunState.running;
        },
      );

      _runTimer.start((time) {
        setState(() {
          elapsed = time;
          });
        },
      );

      _stepCounter.resume((_) {});

      _sheetController.animateTo (//animates the sheet when running
        0.25,
        duration: const Duration(milliseconds: 300,),
        curve: Curves.easeOut,
      );
    }
  }

  // When run stops, we can save everything here.
  Future<void> _stopRun() async {
    final double finalDistance = currentDistanceMetres;
    final double finalCalories = _calories;
    final String currentPlayerName = currentUsername;
    final String territoryName = _mapKey.currentState?.getSelectedTerritoryName() ?? 'Unknown';

    _mapKey.currentState?.stopTracking();

    lastRun = elapsed;

    final String? runId = await RunService().saveRun(
      elapsed.inSeconds,
      territoryName,
      _steps,
      double.parse(finalCalories.toStringAsFixed(1)),
      double.parse(finalDistance.toStringAsFixed(1)),
    );

    await _mapKey.currentState?.saveCompletedTerritoryRun(
      playerName: currentPlayerName,
      runTime: elapsed,
      runId: runId,
    );

    _runTimer.reset();
    _stepCounter.reset();

    if (!mounted) {
      return;
    }

    setState(() { //resets the run details
      runState = RunState.idle;
      elapsed = Duration.zero;
      currentDistanceMetres = 0.0;
      _steps = 0;
      _calories = 0.0;
    });

    //animates the sheet when running
    _sheetController.animateTo (0.35,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _runTimer.pause();
    _mapKey.currentState?.stopTracking();
    _stepCounter.stop();
    _usernameStream?.cancel();
    super.dispose();
  }

  Future<void> _loadPrivacySetting() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    AppSettingsService.privateProfile.value = doc.data()?['isPrivate'] ?? false;
  }

  @override
  void initState() {
    super.initState();
    _loadPrivacySetting();

    //sync territory when opening app
    TerritorySyncService().syncTerritoryRecords();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _usernameStream = FirebaseFirestore.instance
          .collection('users').doc(user.uid).snapshots().listen((doc) {
        final data = doc.data();
        final username = data?['username'];
        setState(() {
          currentUsername = (username == null || username.trim().isEmpty)
              ? user.email ?? 'Guest Runner' : username;
        });
      });

    }

    _sheetController.addListener(() {
      setState(() {_sheetSize = _sheetController.size;});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonBottom = screenHeight * _sheetSize + 10;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          'Homepage Page',
        ),
        actions: [
          // ---> scoreboard button
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/scoreboard_page',
            ),

            icon: const Icon(
              Icons.leaderboard_outlined,
            ),

            iconSize: 28,
          ),

          // ---> friends button
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/my_friends_page',
            ),

            icon: const Icon(
              Icons.people_alt_outlined,
            ),

            iconSize: 28,

          ),
        ],
      ),

      body: Stack(
        children: [
          // Google Map.
          GMap(
            key: _mapKey,
            onDistanceChanged: (distance) {
              if (!mounted) return;
              if (runState != RunState.running) return;
              setState(() {
                currentDistanceMetres = distance;
                _calories = (distance / 1000) * 60; //calculates calories based on distance
              });
            },
          ),

          // Reset camera position button.
          Positioned(
            right: 16,
            bottom: buttonBottom > screenHeight / 2
                ? 10
                : buttonBottom,
            child: ResetLocationButton(
              onPressed: () {
                _mapKey.currentState?.resetCamera();
              },
            ),
          ),

          // Bottom draggable sheet.
          MyScrollableDraggableSheet(
            controller: _sheetController,
            runState: runState,
            onStartRun: _startRun,
            onStopRun: _stopRun,
            onPauseRun: _pauseRun,
            elapsed: elapsed,
            lastRun: lastRun,
            playerName: currentUsername,
            currentDistanceMetres: currentDistanceMetres,
            steps: _steps,
            calories: _calories,
          ),

          // Start-run button.
          Positioned(
            bottom: 0,
            right: 0,
            left: 0, //bounds
            child: StartRunButton(
              onTap: _startRun, // ---> starts the run will link later
              runState: runState,
              elapsed: elapsed,
            ),
          ),
        ],
      ),

      drawer: const MyDrawer(),
    );
  }
}