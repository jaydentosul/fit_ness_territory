
import 'package:flutter/material.dart';

class MyStatsList extends StatelessWidget{
  final int bestRun;
  final int totalRunTime;
  final int totalRuns;
  final int friends;
  final int totalSteps;
  final double totalDistance;
  final double totalCalories;

  const MyStatsList({
    super.key,
    required this.bestRun,
    required this.totalRunTime,
    required this.totalRuns,
    required this.friends,
    required this.totalSteps,
    required this.totalDistance,
    required this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        spacing: 18,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: Offset(2, 4),
                  )
                ]
            ),
            child: Column(
              children: [
                _myStatsTiles(
                  title: "Best Run",
                  trailingText: "$bestRun sec",
                  icon: Icons.emoji_events,
                ),

                _myStatsTiles(
                  title: "Total Run Time",
                  trailingText: "$totalRunTime sec", // <--------- hook up fireBase
                  icon: Icons.more_time,
                ),

                _myStatsTiles(
                  title: "Total Runs",
                  trailingText: "$totalRuns",
                  icon: Icons.directions_run,
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: Offset(2, 4),
                  )
                ]
            ),
            child: _myStatsTiles(
              title: "Friends",
              trailingText: "$friends",
              icon: Icons.people,
            ),
          ),

          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: Offset(2, 4),
                  )
                ]
            ),
            child: Column(
              children: [
                _myStatsTiles(  // ------------> Steps
                  title: "Total Steps",
                  trailingText: "$totalSteps",     // <------ Hook up fireBase
                  icon: Icons.directions_walk,
                ),

                _myStatsTiles(  // ------------> Distance
                  title: "Distance Travelled",
                  trailingText: "$totalDistance km",  // <------ Hook up fireBase
                  icon: Icons.straighten,
                ),

                _myStatsTiles(  // -------------> Calories
                  title: "Calories",
                  trailingText: "$totalCalories kCal",  // <------ Hook up fireBase
                  icon: Icons.local_fire_department_outlined,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //Tile Widget
  Widget _myStatsTiles({
    required IconData icon,
    required String title,
    required String trailingText,
    double leftRightPadding = 16.0,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: leftRightPadding),
      leading: Icon(icon, color: Colors.green,),
      title: Text(title),
      trailing: Text(
        trailingText,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

}