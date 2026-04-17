import 'package:flutter/material.dart';

/*
Add the friends sections here
 */

class MyFriendsPage extends StatelessWidget{
  const MyFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('My Friends Page'),
      ),
    );
  }
}
