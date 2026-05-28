import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
* this basically just syncs the database in case there has been changes
* even if there is nothing but it double checks anyways
 */

class TerritorySyncService {
  final FirebaseFirestore _db = FirebaseFirestore.instance; //instance of db

  //check runs and updates database
  Future<void> syncTerritoryRecords() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final runsWithTerritoryName = await _db
        .collection('runs')
        .where('territoryName', isGreaterThan: '')
        .get();

    if (runsWithTerritoryName.docs.isEmpty) return;

    //groups the runs based on territory
    final Map<String, Map<String, dynamic>> fastestPerTerritory = {};

    for (final doc in runsWithTerritoryName.docs) {
      final data = doc.data();
      final String territoryName = data['territoryName'] ?? '';
      final int time = data['time'] ?? 0;
      final String username = data['username'] ?? '';

      if (territoryName.isEmpty || time <= 0) continue; //skip

      //check fastest runTime and if no record yet
      if (!fastestPerTerritory.containsKey(territoryName)
          || time < fastestPerTerritory[territoryName]!['time']) {
        fastestPerTerritory[territoryName] = {
          'time': time,
          'username': username,
        };
      }

    }

    //update each territory in the firebase
    for (final entry in fastestPerTerritory.entries) {
      final String territoryName = entry.key;
      final int fastestTime = entry.value['time'];
      final String fastestUsername = entry.value['username'];

      //finds the territory
      final territoryQuery = await _db
          .collection('territories')
          .where('territoryName', isEqualTo: territoryName)
          .get();

      if (territoryQuery.docs.isEmpty) continue; //skip

      //variables for swapping
      final territoryDoc = territoryQuery.docs.first;
      final existingData = territoryDoc.data();
      final int currentFastest = existingData['fastestTimeSeconds'] ?? 0;

      //only update if currentFastest > existingData
      if (currentFastest <= 0 || currentFastest > fastestTime) {
        await territoryDoc.reference.update({
          'fastestTimeSeconds': fastestTime,
          'currentOwner': fastestUsername,
        });
      }
    }
  }
}