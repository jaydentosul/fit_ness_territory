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
}