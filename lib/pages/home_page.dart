import 'package:flutter/material.dart';
import '../components/my_bottom_sheet.dart';
import '../components/my_drawer.dart';
import 'timer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? lastRunTime;

  String formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Homepage Page'),
      ),

      body: Stack(
        children: [

          //  Map placeholder
          Container(
            color: Colors.grey[300],
            child: const Center(
              child: Text(
                "This is for the Map\nfingers crossed",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Last Run display
          if (lastRunTime != null)
            Positioned(
              top: 120,
              left: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Last Run: ${formatTime(lastRunTime!)} s",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

          // Bottom Sheet
          const MyBottomSheet(),

          // Start Run Button
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // start color
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TimerPage(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    lastRunTime = result;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Run time: $result seconds"),
                    ),
                  );
                }
              },
              child: const Text(
                "Start Run",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),

      drawer: MyDrawer(),
    );
  }
}