import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_ness_territory/components/my_buttons.dart';
import 'package:fit_ness_territory/modes/modes.dart';
import 'package:flutter/material.dart';

class MyScrollableDraggableSheet extends StatelessWidget {
  final DraggableScrollableController controller;
  final VoidCallback onStartRun;
  final VoidCallback onStopRun;
  final VoidCallback onPauseRun;
  final RunState runState;
  final Duration elapsed;
  final Duration lastRun;
  final String playerName;
  final double currentDistanceMetres;
  final int steps;
  final double calories;

  const MyScrollableDraggableSheet({
    super.key,
    required this.controller,
    required this.runState,
    required this.onStartRun,
    required this.onStopRun,
    required this.onPauseRun,
    required this.elapsed,
    required this.lastRun,
    required this.playerName,
    required this.currentDistanceMetres,
    required this.steps,
    required this.calories,
  });

  String formatTime(Duration time) {
    final mins = time.inMinutes.toString().padLeft(2, '0');
    final secs = (time.inSeconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  String formatSeconds(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  String formatDistance(double metres) {
    if (metres < 1000) {
      return "${metres.toStringAsFixed(0)} m";
    }

    final double kilometres = metres / 1000;
    return "${kilometres.toStringAsFixed(2)} km";
  }

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required BuildContext context,
  }) {
    return Expanded(
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.green,
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final hPadding = const EdgeInsets.symmetric(horizontal: 18);

    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: 0.42,
      minChildSize: 0.28,
      maxChildSize: 0.70,
      snap: true,
      snapSizes: const [0.28, 0.42, 0.70],

      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),

          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.only(top: 12, bottom: 110),

            children: [
              // dragging handle
              Center(
                child: Container(
                  width: 55,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // player name + pause/stop buttons
              Padding(
                padding: hPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        playerName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),

                    (runState == RunState.running || runState == RunState.pause)
                        ? Row(
                      children: [
                        PauseStopButton(
                          icon: runState == RunState.pause
                              ? Icons.play_arrow
                              : Icons.pause,
                          onPressed: onPauseRun,
                        ),

                        const SizedBox(width: 10),

                        PauseStopButton(
                          icon: Icons.stop,
                          onPressed: onStopRun,
                        ),
                      ],
                    )
                        : const SizedBox(),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // run info card
              Padding(
                padding: hPadding,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, color: Colors.green),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              runState == RunState.running ||
                                  runState == RunState.pause
                                  ? "Current Run"
                                  : "Last Run",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),

                          Text(
                            runState == RunState.running ||
                                runState == RunState.pause
                                ? formatTime(elapsed)
                                : lastRun == Duration.zero
                                ? "--:--"
                                : formatTime(lastRun),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          const Icon(Icons.route_outlined, color: Colors.green),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Distance",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),

                          Text(
                            runState == RunState.running ||
                                runState == RunState.pause
                                ? formatDistance(currentDistanceMetres)
                                : "--",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      user == null
                          ? Row(
                        children: [
                          const Icon(Icons.emoji_events_outlined,
                              color: Colors.green),
                          const SizedBox(width: 10),
                          Text(
                            "Best Run: Not logged in",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      )
                          : StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              !snapshot.data!.exists) {
                            return Row(
                              children: [
                                const Icon(Icons.emoji_events_outlined,
                                    color: Colors.green),
                                const SizedBox(width: 10),
                                Text(
                                  "Best Run",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "--:--",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                ),
                              ],
                            );
                          }

                          final data = snapshot.data!.data()
                          as Map<String, dynamic>;

                          final bestRun = data['bestRun'] ?? 0;

                          return Row(
                            children: [
                              const Icon(Icons.emoji_events_outlined,
                                  color: Colors.green),

                              const SizedBox(width: 10),

                              Text(
                                "Best Run",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              const Spacer(),

                              Text(
                                bestRun == 0
                                    ? "--:--"
                                    : formatSeconds(bestRun),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // steps + calories
              Padding(
                padding: hPadding,
                child: Row(
                  children: [
                    statCard(
                      title: "STEPS",
                      value: steps.toString(),
                      icon: Icons.directions_walk,
                      context: context,
                    ),

                    const SizedBox(width: 16),

                    statCard(
                      title: "CALORIES",
                      value: calories.toStringAsFixed(0),
                      icon: Icons.local_fire_department_outlined,
                      context: context,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}