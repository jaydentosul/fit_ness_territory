import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// handles firebase login and signup
// Also saves new user details into firestore

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // creates a new account and saves user info to database
  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // save user to firestore
        await _db.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'bestRun': 0,
          'totalRuns': 0,
          'friends': [], // empty list for friends
        });
      }

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // logs in an existing user
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //deletes current user account
  Future<bool> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      //delete user data frm firestore first
      await _db.collection('users').doc(user.uid).delete();

      //then delete the login/auth accounts
      await user.delete();

      //deleting all data related to the user
      final runs = await _db.collection('runs').where('userId', isEqualTo: user.uid).get();
      for (final doc in runs.docs) {
        await doc.reference.delete();
      }

      //remove from friend list
      final allUsers = await _db.collection('users').get();
      for (final doc in allUsers.docs) {
        await doc.reference.update({
          'friends': FieldValue.arrayRemove([user.uid]),
        });
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateUsername(String newUsername) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).update({
      'username': newUsername,
    });
  }

}