import 'package:flutter/material.dart';


/*
This where the profile stuff goes
*/

class MyProfilePage extends StatelessWidget{
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('My Profile Page'),
      ),

      body: ListView(
        padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
        children: [
          Center( // ---> player image/icon
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.shade400,
              ),
              child: Icon(
                Icons.person_4_outlined,
                size: 100,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          
          Text('Name')
        ],
      ),

    );
  }
}