import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_ness_territory/services/territory_sync_service.dart';

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
          'profilePicUrl': '',
          'totalRunTime': 0,
          'totalSteps': 0,
          'distanceTravelled': 0.0,
          'totalCalories': 0.0,
          'isPrivate': false
        });
      }

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sends password reset email
  Future<void> sendPasswordReset(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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

      //gets the username before deleting anything
      final userSnapshot = await _db.collection('users').doc(user.uid).get();
      final userData = userSnapshot.data();
      final username = userData?['username'] ?? '';

      //delete user data frm firestore first
      await _db.collection('users').doc(user.uid).delete();

      //refreshes the scoreBoard
      TerritorySyncService().syncTerritoryRecords();

      //then delete the login/auth accounts
      await user.delete();

      //deleting all runs related to the user ID
      final runs = await _db.collection('runs').where('userId', isEqualTo: user.uid).get();
      for (final doc in runs.docs) {
        await doc.reference.delete();
      }

      //remove from leaderboard as well
      if (username.isNotEmpty) {
        final territories = await _db.collection('territories')
            .where('currentOwner', isEqualTo: username).get();

        for (final doc in territories.docs) {
          await doc.reference.update({
            'currentOwner' : '',
            'fastestTimeSeconds' : 0
          });
        }
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

  Future<String?> uploadProfilePicture(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {//convert the image to base64 coz storage is an upgrade plan
      final bytes = await imageFile.readAsBytes();
      final base64Str = base64Encode(bytes);
      final dataUrl = 'data:image/jpeg;base64,$base64Str';

      await _db.collection('users').doc(user.uid).update({
        'profilePicUrl': dataUrl,
      });

      return dataUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

}