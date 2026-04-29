import 'package:flutter/material.dart';


/*
This is where we can build the UI for the LeaderBoard
*/

class ScoreboardPage extends StatelessWidget{
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Scoreboard Page'),
      ),
    );
  }
}
