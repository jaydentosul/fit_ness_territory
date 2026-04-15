import 'package:flutter/material.dart';

class ScoreboardPage extends StatelessWidget{
  const ScoreboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Scoreboard Page'),
      ),

      /*
      This is where we can build the UI for the LeaderBoard
       */

    );
  }
}