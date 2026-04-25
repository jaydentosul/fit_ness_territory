import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: const Text('Scoreboard Page'),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          // leaderboard title
          const Text(
            " 🏆 LEADERBOARD ",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // shows leaderboard using users best run times from firebase
          // can change to territory leaderboard later
          Expanded(
            // gets top users ordered by best run
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('bestRun', isGreaterThan: 0)
                  .orderBy('bestRun')
                  .limit(10)
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;

                if (users.isEmpty) {
                  return const Center(child: Text("No leaderboard data yet"));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {

                    final user = users[index];
                    final data = user.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile( //shows users rank and best run
                        leading: CircleAvatar(
                          child: Text("#${index + 1}"),
                        ),
                        title: Text(
                          data['username'] ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text("Best Run: ${data['bestRun']} sec"),
                        trailing: index == 0
                            ? const Icon(Icons.emoji_events)
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}