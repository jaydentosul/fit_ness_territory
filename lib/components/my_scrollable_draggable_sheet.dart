import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_ness_territory/components/my_buttons.dart';
import 'package:fit_ness_territory/modes/modes.dart';
import 'package:flutter/material.dart';

class MyScrollableDraggableSheet extends StatelessWidget
{
  final DraggableScrollableController controller;
  final VoidCallback onStartRun;
  final VoidCallback onStopRun;
  final VoidCallback onPauseRun;
  final RunState runState;
  final Duration elapsed; // current run time
  final Duration lastRun;
  final String playerName;

  const MyScrollableDraggableSheet
      ({
    super.key,
    required this.controller,
    required this.runState,
    required this.onStartRun,
    required this.onStopRun,
    required this.onPauseRun,
    required this.elapsed,
    required this.lastRun,
    required this.playerName,
  });

  String formatTime(Duration time)
  {
    final mins = time.inMinutes.toString().padLeft
      (
      2,
      '0',
    );

    final secs = (time.inSeconds % 60).toString().padLeft
      (
      2,
      '0',
    );

    return "$mins:$secs";
  }

  String formatSeconds(int seconds)
  {
    final mins = (seconds ~/ 60).toString().padLeft
      (
      2,
      '0',
    );

    final secs = (seconds % 60).toString().padLeft
      (
      2,
      '0',
    );

    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context)
  {
    final user = FirebaseAuth.instance.currentUser;

    return DraggableScrollableSheet
      (
      controller: controller,
      initialChildSize: 0.35, //initial start of the sheet
      minChildSize: 0.25,     //highest length to drag to
      maxChildSize: 0.85,     //lowest length to drag to
      snap: true,
      snapSizes: const
      [
        0.25,
        0.35,
        0.85,
      ],
      builder: (context, scrollController)
      {
        return Container
          (
          decoration: BoxDecoration
            (
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: const BorderRadius.vertical
              (
              top: Radius.circular
                (
                24,
              ),
            ),
          ),

          child: ListView
            (
            controller: scrollController,
            padding: const EdgeInsets.only
              (
              top: 12,
            ),
            children:
            [
              //DRAGGING HANDLE
              Center
                (
                child: Container
                  (
                  width: 55,
                  height: 4,
                  decoration: BoxDecoration
                    (
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular
                      (
                      20,
                    ),
                  ),
                ),
              ),

              const SizedBox
                (
                height: 30,
              ),

              /*
                Can fill up this section with player stats as similar to
                the figma model
              */
              Padding
                (
                padding: const EdgeInsets.symmetric
                  (
                  horizontal: 15,
                ),
                child: Row
                  (
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    Expanded
                      (
                      child: Text
                        (
                        playerName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle
                          (
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    (runState == RunState.running || runState == RunState.pause)
                        ? Row
                      (
                      children:
                      [
                        // PAUSE
                        PauseStopButton
                          (
                          icon: runState == RunState.pause
                              ? Icons.play_arrow
                              : Icons.pause,
                          onPressed: onPauseRun,
                        ),

                        const SizedBox
                          (
                          width: 10,
                        ),

                        // STOP
                        PauseStopButton
                          (
                          icon: Icons.stop,
                          onPressed: onStopRun,
                        ),
                      ],
                    )
                        : const SizedBox(),
                  ],
                ),
              ),

              const SizedBox
                (
                height: 25,
              ),

              /*
                More UI stuff for player Info
               */

              // shows last run and best run at the bottom of the sheet on player info
              Padding
                (
                padding: const EdgeInsets.symmetric
                  (
                  horizontal: 15,
                ),
                child: Text
                  (
                  runState == RunState.running || runState == RunState.pause
                      ? "Current Run: ${formatTime(elapsed)}"
                      : "Last Run: ${lastRun == Duration.zero ? '--:--' : formatTime(lastRun)}",
                  style: const TextStyle
                    (
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox
                (
                height: 10,
              ),

              Padding
                (
                padding: const EdgeInsets.symmetric
                  (
                  horizontal: 15,
                ),
                child: user == null
                    ? const Text
                  (
                  "Best Run: Not logged in",
                  style: TextStyle
                    (
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                )
                    : StreamBuilder<DocumentSnapshot>
                  (
                  stream: FirebaseFirestore.instance //gets the best run from firebase (change to territory later)
                      .collection
                    (
                    'users',
                  )
                      .doc
                    (
                    user.uid,
                  )
                      .snapshots(),
                  builder: (context, snapshot)
                  {
                    if (!snapshot.hasData || !snapshot.data!.exists)
                    {
                      return const Text
                        (
                        "Best Run: --:--",
                        style: TextStyle
                          (
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      );
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final bestRun = data['bestRun'] ?? 0;

                    return Text
                      (
                      "Best Run: ${bestRun == 0 ? '--:--' : formatSeconds(bestRun)}",
                      style: const TextStyle
                        (
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox
                (
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}