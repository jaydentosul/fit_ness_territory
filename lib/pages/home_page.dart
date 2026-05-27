import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_ness_territory/components/run_timer.dart';
import 'package:fit_ness_territory/modes/modes.dart';
import 'package:flutter/material.dart';

import '../components/my_buttons.dart';
import '../components/my_drawer.dart';
import '../components/my_scrollable_draggable_sheet.dart';
import '../map/g_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DraggableScrollableController _sheetController =
  DraggableScrollableController();

  final GlobalKey<GMapState> _mapKey = GlobalKey<GMapState>();
  final RunTimer _runTimer = RunTimer();

  double _sheetSize = 0.35;
  RunState runState = RunState.idle;
  Duration elapsed = Duration.zero;
  Duration lastRun = Duration.zero;
  double currentDistanceMetres = 0.0;
  String currentUsername = 'Loading...';

  Future<void> _loadCurrentUsername() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      setState(() {
        currentUsername = 'Guest Runner';
      });

      return;
    }

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
    await FirebaseFirestore.instance
        .collection(
      'users',
    )
        .doc(
      currentUser.uid,
    )
        .get();

    final Map<String, dynamic>? userData = userDoc.data();

    if (userData == null) {
      setState(() {
        currentUsername = currentUser.email ?? 'Guest Runner';
      });

      return;
    }

    final String? username = userData['username'];

    setState(() {
      currentUsername = username == null || username.trim().isEmpty
          ? currentUser.email ?? 'Guest Runner'
          : username;
    });
  }

  Future<String> _getCurrentUsername() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return 'Guest Runner';
    }

    final DocumentSnapshot<Map<String, dynamic>> userDoc =
    await FirebaseFirestore.instance
        .collection(
      'users',
    )
        .doc(
      currentUser.uid,
    )
        .get();

    final Map<String, dynamic>? userData = userDoc.data();

    if (userData == null) {
      return currentUser.email ?? 'Guest Runner';
    }

    final String? username = userData['username'];

    if (username == null || username.trim().isEmpty) {
      return currentUser.email ?? 'Guest Runner';
    }

    return username;
  }

  Future<void> _startRun() async {
    if (runState == RunState.idle) {
      final bool canStartRun =
          await _mapKey.currentState?.prepareRunFromSelectedTerritory() ??
              false;

      if (!canStartRun) {
        return;
      }

      setState(() {
        runState = RunState.running;
        elapsed = Duration.zero;
        currentDistanceMetres = 0.0;
      });

      // Resets and starts the timer.
      _runTimer.reset();
      _runTimer.start(
            (time) {
          setState(() {
            elapsed = time;
          });
        },
      );

      // Animates the sheet when running.
      _sheetController.animateTo(
        0.25,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut,
      );
    }
  }

  void _pauseRun() {
    // Pausing.
    if (runState == RunState.running) {
      _runTimer.pause();
      _mapKey.currentState?.pauseTracking();

      setState(() {
        runState = RunState.pause;
      });

      // Pressing play again.
    } else if (runState == RunState.pause) {
      _mapKey.currentState?.resumeTracking();

      setState(() {
        runState = RunState.running;
      });

      _runTimer.start(
            (time) {
          setState(() {
            elapsed = time;
          });
        },
      );

      // Animates the sheet when running.
      _sheetController.animateTo(
        0.25,
        duration: const Duration(
          milliseconds: 300,
        ),
        curve: Curves.easeOut,
      );
    }
  }

  // When run stops, we can save everything here.
  Future<void> _stopRun() async {
    _mapKey.currentState?.stopTracking();

    lastRun = elapsed;

    final String currentPlayerName = await _getCurrentUsername();

    await _runTimer.saveRun();

    await _mapKey.currentState?.saveCompletedTerritoryRun(
      runTime: elapsed,
      playerName: currentPlayerName,
    );

    _runTimer.reset();

    if (!mounted) {
      return;
    }

    setState(() {
      runState = RunState.idle;
      elapsed = Duration.zero;
      currentDistanceMetres = 0.0;
      currentUsername = currentPlayerName;
    });

    // Animates the sheet after run stops.
    _sheetController.animateTo(
      0.35,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _runTimer.pause();
    _mapKey.currentState?.stopTracking();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _loadCurrentUsername();

    _sheetController.addListener(
          () {
        setState(() {
          _sheetSize = _sheetController.size;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonBottom = screenHeight * _sheetSize + 10;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Home Page',
        ),
        actions: [
          // Scoreboard button.
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

          // Friends button.
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
              if (!mounted) {
                return;
              }

              setState(() {
                currentDistanceMetres = distance;
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
          ),

          // Start-run button.
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: StartRunButton(
              onTap: _startRun,
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