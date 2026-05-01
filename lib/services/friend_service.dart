import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// handles adding friends using username

class FriendService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // add friend by username
  Future<void> addFriend(String username) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // find user with that username
    final query = await _db
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    // if no user found, stop
    if (query.docs.isEmpty) return;

    final friendDoc = query.docs.first;
    final friendId = friendDoc.id;

    // adds friend instantly (change to requests later?)
    await _db.collection('users').doc(currentUser.uid).update({
      'friends': FieldValue.arrayUnion([friendId]),
    });
  }
}