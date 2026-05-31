import 'package:fit_ness_territory/components/my_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/my_stats_list.dart';

class ViewFriendPage extends StatelessWidget {
  final String friendId;

  const ViewFriendPage({super.key, required this.friendId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
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
          final totalRunTime = data?['totalRunTime'] ?? 0;
          final totalSteps = data?['totalSteps'] ?? 0;
          final distanceTravelled = data?['distanceTravelled'] ?? 0.0;
          final totalCalories = data?['totalCalories'] ?? 0.0;
          final isPrivate = data?['isPrivate'] ?? false;

          if (isPrivate) {
            return const Center(
              child: Text("This profile is private"),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 18,),

                Center(// profile picture
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey.shade400,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: MyProfileAvatar(
                        profileUrl: data?['profilePicUrl'] as String,
                        size: 200,
                      )
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                const SizedBox(height: 25),

                MyStatsList(
                  bestRun: bestRun,
                  totalRunTime: totalRunTime,
                  totalRuns: totalRuns,
                  friends: friends.length,
                  totalSteps: totalSteps,
                  totalDistance: distanceTravelled,
                  totalCalories: totalCalories,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}