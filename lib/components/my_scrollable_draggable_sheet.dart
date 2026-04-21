import 'package:fit_ness_territory/components/my_buttons.dart';
import 'package:fit_ness_territory/modes/modes.dart';
import 'package:flutter/material.dart';

class MyScrollableDraggableSheet extends StatelessWidget{
  final DraggableScrollableController controller;
  final VoidCallback onStartRun;
  final VoidCallback onStopRun;
  final VoidCallback onPauseRun;
  final RunState runState;

  const MyScrollableDraggableSheet({
    super.key,
    required this.controller,
    required this.runState,
    required this.onStartRun,
    required this.onStopRun,
    required this.onPauseRun,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: controller,
      initialChildSize: 0.35, //initial start of the sheet
      minChildSize: 0.25,     //highest length to drag to
      maxChildSize: 0.85,     //lowest length to drag to
      snap: true,
      snapSizes: const [0.25, 0.35, 0.85],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              )
          ),

          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.only(top: 12),
            children: [

              //DRAGGING HANDLE
              Center(
                child: Container(
                  width: 55,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /*
                Can fill up this section with player stats as similar to
                the figma model
              */
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SK!PP3R678",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),

                    (runState == RunState.running || runState == RunState.pause) ?
                    Row(
                      children: [
                        // PAUSE
                        PauseStopButton(
                          icon: runState == RunState.pause ?
                          Icons.play_arrow : Icons.pause,
                          onPressed: onPauseRun,
                        ),

                        const SizedBox(width: 10),

                        // STOP
                        PauseStopButton(
                          icon: Icons.stop,
                          onPressed: onStopRun,
                        ),
                      ],
                    ) : const SizedBox(),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /*
                More UI stuff for player Info
               */

              // const SizedBox(height: 800,)
            ],
          ),

        );
      },
    );
  }
}