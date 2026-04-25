import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
This where the profile stuff goes
*/

class MyProfilePage extends StatelessWidget{
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('My Profile Page'),
      ),

      body: user == null
          ? const Center(child: Text("Not logged in"))
          : StreamBuilder<DocumentSnapshot>(  // gets current users profile from data in firestore
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          final username = data?['username'] ?? 'Unknown';
          final email = data?['email'] ?? '';
          final bestRun = data?['bestRun'] ?? 0;
          final totalRuns = data?['totalRuns'] ?? 0;
          final friends = List<String>.from(data?['friends'] ?? []);

          return ListView(
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

              const SizedBox(height: 20),

              Center(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Center(
                child: Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // displays user stats best run etc
              ListTile(
                leading: Icon(Icons.timer),
                title: Text("Best Run"),
                trailing: Text("$bestRun sec"),
              ), // basic stats for now, should add more like distance or achievements

              ListTile(
                leading: Icon(Icons.directions_run),
                title: Text("Total Runs"),
                trailing: Text("$totalRuns"),
              ),

              ListTile(
                leading: Icon(Icons.people),
                title: Text("Friends"),
                trailing: Text("${friends.length}"),
              ),
            ],
          );
        },
      ),
    );
  }
}