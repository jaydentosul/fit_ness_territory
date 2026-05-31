import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_ness_territory/services/territory_sync_service.dart';
import 'package:flutter/material.dart';
import '../components/my_territory_list.dart';

/*
This is where we can build the UI for the territory leaderboard
*/

class ScoreboardPage extends StatelessWidget {
  const ScoreboardPage({
    super.key,
  });

  String formatSeconds(int seconds) {
    if (seconds <= 0) return '--:--';
    final mins = (seconds ~/ 60).toString().padLeft(2, '0',);
    final secs = (seconds % 60).toString().padLeft(2, '0',);
    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "TERRITORY LEADERS ",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [ //refresh button
          IconButton(
            onPressed: () {
              TerritorySyncService().syncTerritoryRecords(); //refreshes Leaderboard
            },
            icon: Icon(Icons.refresh, size: 30,),
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('territories')
            .where('fastestTimeSeconds', isGreaterThanOrEqualTo: 0)
            .orderBy('fastestTimeSeconds')
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading leaderboard"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final territories = snapshot.data!.docs;

          if (territories.isEmpty) {
            return const Center(child: Text("No territory records yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: territories.length,
            itemBuilder: (context, index) {
              final data = territories[index].data() as Map<String, dynamic>;

              final String imageUrl = data['imageUrl'] ?? 'assets/auckland_domain_track.png';
              final String territoryName = data['territoryName'] ?? 'Unknown Territory';
              final String ownerName = data['currentOwner'] ?? ' ';
              final dynamic fastestValue = data['fastestTimeSeconds'];

              int fastestTimeSeconds = 0;
              if (fastestValue is int) {
                fastestTimeSeconds = fastestValue;
              } else if (fastestValue is double) {
                fastestTimeSeconds = fastestValue.round();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MyListTerritory(
                  onTap: () {},
                  imgPath: imageUrl,
                  territoryName: territoryName,
                  ownerName: ownerName,
                  bestTime: formatSeconds(fastestTimeSeconds),
                ),
              );
            },
          );
        },
      ),
    );

  }
}