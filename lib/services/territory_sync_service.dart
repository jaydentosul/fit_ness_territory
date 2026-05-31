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
      final String runId = doc.id; //gets run id

      if (territoryName.isEmpty || time <= 0) continue; //skip

      //check fastest runTime and if no record yet
      if (!fastestPerTerritory.containsKey(territoryName)
          || time < fastestPerTerritory[territoryName]!['time']) {
        fastestPerTerritory[territoryName] = {
          'time': time,
          'username': username,
          'runId': runId,
        };
      }
    }

    //update each territory in the firebase
    for (final entry in fastestPerTerritory.entries) {
      final String territoryName = entry.key;
      final int fastestTime = entry.value['time'];
      final String fastestUsername = entry.value['username'];
      final String fastestRunId = entry.value['runId'];

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
      final String existingRunId = existingData['runId'].toString();

      //if a runId is already stored and double checks
      if (existingRunId.isNotEmpty) {
        final runDoc = await _db.collection('runs').doc(existingRunId).get();

        if(runDoc.exists) {
          final int actualTime = runDoc.data()?['time'] ?? 0;

          if (actualTime != currentFastest) {
            await territoryDoc.reference.update({
              'fastestTimeSeconds': actualTime,
              'currentOwner': runDoc.data()?['username'] ?? fastestUsername,
              'runId': existingRunId,
            });
            continue;
          }
        } else {
          await territoryDoc.reference.update({
            'fastestTimeSeconds': fastestTime,
            'currentOwner': fastestUsername,
            'runId': fastestRunId,
          });
          continue;
        }
      }

      //check if a runTime is faster > existingData
      if (currentFastest <= 0 || currentFastest > fastestTime) {
        await territoryDoc.reference.update({
          'fastestTimeSeconds': fastestTime,
          'currentOwner': fastestUsername,
          'runId': fastestRunId,
        });
      }
    }

    //check for deadRuns or Non-existence runs
    final allTerritories = await _db.collection('territories').get();
    for (final territoryDoc in allTerritories.docs) {
      final existingData = territoryDoc.data();
      final String existingRunId = existingData['runId'].toString();
      final String territoryName = existingData['territoryName'] ?? '';

      if (existingRunId.isEmpty) continue;

      //check if the run ID points to a real run
      final runDoc = await _db.collection('runs').doc(existingRunId).get();
      if(!runDoc.exists) {
        final remainingRuns = await _db
            .collection('runs')
            .where('territoryName', isEqualTo: territoryName)
            .get();

        if(remainingRuns.docs.isEmpty) {
          await territoryDoc.reference.update({
            'fastestTimeSeconds': 0,
            'currentOwner': ' ',
            'runId': ''
          });
        }
      }
    }
  }
}