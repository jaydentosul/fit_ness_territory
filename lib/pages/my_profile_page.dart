import 'package:flutter/material.dart';

class MyProfilePage extends StatelessWidget{
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('My Profile Page'),
      ),

      /*
      This where the Settings part goes
       */

    );
  }
}