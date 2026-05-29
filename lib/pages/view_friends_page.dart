import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewFriendPage extends StatelessWidget {
  final String friendId;

  const ViewFriendPage({super.key, required this.friendId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Friends Profile'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(friendId)
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

          final double leftRightPadding = 70.0;

          String formatSeconds(int seconds) {
            if (seconds <= 0) return '--:--';
            final mins = (seconds ~/ 60).toString().padLeft(2, '0');
            final secs = (seconds % 60).toString().padLeft(2, '0');
            return "$mins:$secs";
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // profile picture
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.shade400,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: (data?['profilePicUrl'] != null &&
                      data!['profilePicUrl'].toString().isNotEmpty)
                      ? Builder(builder: (context) {
                        final url = data['profilePicUrl'] as String;
                      //decodes the base64 for the image
                        if (url.startsWith('data:image')) {
                          final base64Str = url
                              .split(',')
                              .last;
                          final bytes = base64Decode(base64Str);
                          return Image.memory(
                            bytes,
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          );
                        }
                        return Image.network('null'); //if change to firestore then use Image.network
                      }) : Icon(
                        Icons.person_4_outlined,
                        size: 100,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // username
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // email
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 30),

                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: leftRightPadding),
                  leading: const Icon(Icons.timer),
                  title: const Text("Best Run"),
                  trailing: Text(
                    formatSeconds(bestRun),
                    style: const TextStyle(fontSize: 15),
                  ),
                ),

                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: leftRightPadding),
                  leading: const Icon(Icons.directions_run),
                  title: const Text("Total Runs"),
                  trailing: Text(
                    "$totalRuns",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),

                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: leftRightPadding),
                  leading: const Icon(Icons.people),
                  title: const Text("Friends"),
                  trailing: Text(
                    "${friends.length}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}