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
  Future<void> saveRun(int time) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _db.collection('users').doc(user.uid);

    // get user info so we can save username with the run
    final userSnapshot = await userRef.get();
    final userData = userSnapshot.data();
    final username = userData?['username'] ?? user.email ?? 'Unknown';

    // save run
    await _db.collection('runs').add({
      'userId': user.uid,
      'username': username,
      'time': time,
      'date': Timestamp.now(),
    }); // later we can add territory + GPS data here (from map feature)

    // update totalRuns
    await userRef.update({
      'totalRuns': FieldValue.increment(1),
    });

    // get current bestRun
    final updatedSnapshot = await userRef.get();
    final updatedData = updatedSnapshot.data();

    final bestRun = updatedData?['bestRun'] ?? 0;

    // update bestRun if faster
    if (bestRun == 0 || time < bestRun) {
      await userRef.update({
        'bestRun': time,
      }); // this is overall best run for now, can change to per territory later
    }
  }
}