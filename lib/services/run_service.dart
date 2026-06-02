import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* don't change the firestore field names
user - username, email, bestRun, totalRuns, friends
runs - userId, username time, date
if changed then all files needs to be updated
 */

class RunService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // saves the run time to firebase and updates user stats
  Future<String?> saveRun(
      int time,
      String territoryName,
      int steps,
      double distanceMeters,
      double calories,
    ) async {
    final user = _auth.currentUser;
    if (user == null) return '';

    final userRef = _db.collection('users').doc(user.uid);

    // get user info so we can save username with the run
    final userSnapshot = await userRef.get();
    final userData = userSnapshot.data();
    final username = userData?['username'] ?? user.email ?? 'Unknown';

    //get data from firebase and check if a run exist based on territory
    final existingRun = await _db
        .collection('runs')
        .where('userId', isEqualTo: user.uid)
        .where('territoryName', isEqualTo: territoryName)
        .get();

    String? savedRunId;

    //save run of no run exists
    if (existingRun.docs.isEmpty) {
      final docRef = await _db.collection('runs').add({
        'userId': user.uid,
        'username': username,
        'time': time,
        'date': Timestamp.now(),
        'territoryName': territoryName,
      });
      savedRunId = docRef.id;//captures the run ID
    } else {  //run exists, check fastestTime
      final existingDoc = existingRun.docs.first;
      final int existingTime = existingDoc.data()['time'] ?? 0;

      if (time < existingTime) {
        await existingDoc.reference.update({
          'time': time,
          'date': Timestamp.now(),
          'username': username,
        });
      }
      savedRunId = existingDoc.id;  //ID of existing run
    }

    // update totalRuns
    await userRef.set({
      'totalRuns': FieldValue.increment(1),
      'totalRunTime': FieldValue.increment(time),
      'totalSteps': FieldValue.increment(steps),
      'distanceTravelled': FieldValue.increment(distanceMeters),
      'totalCalories': FieldValue.increment(calories),
    }, SetOptions(merge: true));

    // get current bestRun
    final updatedSnapshot = await userRef.get();
    final updatedData = updatedSnapshot.data();
    final bestRun = updatedData?['bestRun'] ?? 0;

    // update bestRun if faster
    if (bestRun == 0 || time < bestRun) {
      await userRef.set({
        'bestRun': time,
      }, SetOptions(merge: true)); // this is overall best run for now, can change to per territory later
    }

    return savedRunId;
  }
}