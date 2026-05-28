import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// handles adding friends using username

class FriendService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //ADDING A FRIEND
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

    // adds user friend's list
    await _db.collection('users').doc(friendId).update({
      'friends': FieldValue.arrayUnion([currentUser.uid]),
    });
  }

  //DELETES FRIEND
  Future<void> deleteFriend(String username) async {
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

    // deletes friend
    await _db.collection('users').doc(currentUser.uid).update({
      'friends': FieldValue.arrayRemove([friendId]),
    });

    // deletes user from friend's list
    await _db.collection('users').doc(friendId).update({
      'friends': FieldValue.arrayRemove([currentUser.uid]),
    });
  }
}