import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*
This is where we can build the UI for the territory leaderboard
*/

class ScoreboardPage extends StatelessWidget
{
  const ScoreboardPage
      ({
    super.key,
  });

  String formatSeconds(int seconds)
  {
    if (seconds <= 0)
    {
      return '--:--';
    }

    final mins = (seconds ~/ 60).toString().padLeft
      (2,'0',);

    final secs = (seconds % 60).toString().padLeft
      (2,'0',);

    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
      (
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar
        (
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text
          (
          'Scoreboard Page',
        ),
      ),

      body: Column
        (
        children:
        [
          const SizedBox
            (
            height: 20,
          ),

          const Text
            (
            " 🏆 TERRITORY LEADERBOARD ",
            textAlign: TextAlign.center,
            style: TextStyle
              (
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox
            (
            height: 20,
          ),

          Expanded
            (
            child: StreamBuilder<QuerySnapshot>
              (
              stream: FirebaseFirestore.instance
                  .collection
                (
                'territories',
              )
                  .where
                (
                'fastestTimeSeconds',
                isGreaterThan: 0,
              )
                  .orderBy
                (
                'fastestTimeSeconds',
              )
                  .snapshots(),
              builder: (context, snapshot)
              {
                if (snapshot.hasError)
                {
                  return Center
                    (
                    child: Padding
                      (
                      padding: const EdgeInsets.all
                        (
                        16,
                      ),
                      child: Text
                        (
                        'Error loading leaderboard: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (!snapshot.hasData)
                {
                  return const Center
                    (
                    child: CircularProgressIndicator(),
                  );
                }

                final territories = snapshot.data!.docs;

                if (territories.isEmpty)
                {
                  return const Center
                    (
                    child: Text
                      (
                      "No territory records yet",
                    ),
                  );
                }

                return ListView.builder
                  (
                  itemCount: territories.length,
                  itemBuilder: (context, index)
                  {
                    final territory = territories[index];
                    final data = territory.data() as Map<String, dynamic>;

                    final String territoryName =
                        data['territoryName'] ?? 'Unknown Territory';

                    final String currentOwner =
                        data['currentOwner'] ?? 'No owner yet';

                    final dynamic fastestValue = data['fastestTimeSeconds'];

                    int fastestTimeSeconds = 0;

                    if (fastestValue is int)
                    {
                      fastestTimeSeconds = fastestValue;
                    }
                    else if (fastestValue is double)
                    {
                      fastestTimeSeconds = fastestValue.round();
                    }

                    return Card
                      (
                      margin: const EdgeInsets.symmetric
                        (
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile
                        (
                        leading: CircleAvatar
                          (
                          child: Text
                            (
                            "#${index + 1}",
                          ),
                        ),

                        title: Text
                          (
                          territoryName,
                          style: const TextStyle
                            (
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Column
                          (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                          [
                            Text
                              (
                              "Owner: $currentOwner",
                            ),

                            const SizedBox
                              (
                              height: 4,
                            ),

                            Text
                              (
                              "Fastest Time: ${formatSeconds(fastestTimeSeconds)}",
                            ),
                          ],
                        ),

                        trailing: index == 0
                            ? const Icon
                          (
                          Icons.emoji_events,
                        )
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