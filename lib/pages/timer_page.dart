import 'package:flutter/material.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;

  // controls if we are showing summary screen or timer screen
  bool showSummary = false;

  @override
  void initState() {
    super.initState();
    startTimer(); // auto start
  }

  // starts or resumes timer
  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds++;
      });
    });

    isRunning = true;
  }

  // pauses timer
  void pauseTimer() {
    timer?.cancel();
    isRunning = false;
    setState(() {});
  }

  // resets timer
  void resetTimer() {
    timer?.cancel();
    seconds = 0;
    isRunning = false;
    setState(() {});
  }

  // ends run and shows summary instead of leaving page
  void endRun() {
    timer?.cancel();

    setState(() {
      showSummary = true;
    });
  }

  // go back to homepage and send time
  void goBackHome() {
    Navigator.pop(context, seconds);
  }

  // formats time better
  String formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // fake stats for now (should be able to connect later)
    final distance = (seconds * 0.02).toStringAsFixed(2);
    final calories = (seconds * 0.8).toInt();

    return Scaffold(
      appBar: AppBar(
        title: Text(showSummary ? "Run Summary" : "Run Timer"),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: showSummary
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // simple icon
              const Icon(Icons.emoji_events,
                  size: 60, color: Colors.orange),

              const SizedBox(height: 20),

              const Text(
                "Run Complete!",
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              // run stats
              Text("Time: ${formatTime(seconds)}"),
              Text("Distance: $distance km"),
              Text("Calories: $calories kcal"),

              const SizedBox(height: 40),

              // back button
              ElevatedButton(
                onPressed: goBackHome,
                child: const Text("Back to Home"),
              )
            ],
          )

          // TIMER UI
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // timer display
              Text(
                formatTime(seconds),
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // pause and resume
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRunning
                          ? Colors.orange
                          : Colors.green,
                    ),
                    onPressed:
                    isRunning ? pauseTimer : startTimer,
                    child: Text(
                        isRunning ? "Pause" : "Resume"),
                  ),

                  const SizedBox(width: 10),

                  // reset
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: resetTimer,
                    child: const Text("Reset"),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ending the run
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                ),
                onPressed: endRun,
                child: const Text("End Run"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}