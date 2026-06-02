import 'dart:io';

import 'package:fit_ness_territory/components/my_profile_avatar.dart';
import 'package:fit_ness_territory/components/my_stats_list.dart';
import 'package:fit_ness_territory/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

/*
This where the profile stuff goes
*/

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  File? _pendingImage;  //stores picked image before saving to fireBase

  bool _isSaving = false;
  bool _isEditing = false;
  final bool _isUploadingPhoto = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _toggleEditMode(String currentUsername) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _usernameController.text = currentUsername;
      } else {
        _pendingImage = null;
      }
    });
  }

  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );

    if (picked == null) return;

    setState(() => _pendingImage = File(picked.path));
  }

  Future<void> _save() async {
    final newUsername = _usernameController.text.trim();
    if (newUsername.isEmpty) return;

    setState(() => _isSaving = true);

    if (_pendingImage != null) {//uploads image
      await AuthService().uploadProfilePicture(_pendingImage!);
      _pendingImage = null;
    }

    await AuthService().updateUsername(newUsername);//updates username

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _isEditing = false;
    });

    //notifier
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // background shifts to a light blue tint when editing
    final bgColor = _isEditing
        ? Theme.of(context).colorScheme.inversePrimary
        : Theme.of(context).colorScheme.tertiary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: bgColor,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(_isEditing ? 'Edit Profile' : 'My Profile Page'),
          actions: [
            user == null
                ? const SizedBox()
                : StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final data = snapshot.data?.data() as Map<String, dynamic>?;
                      final username = data?['username'] ?? '';

                      if (_isEditing) {
                        return Row(
                          children: [
                            // cancel
                            IconButton(
                              onPressed: () => _toggleEditMode(username),
                              icon: const Icon(Icons.close, size: 28),
                              color: Colors.red,
                            ),
                            // save
                            _isSaving
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    onPressed: _save,
                                    icon: const Icon(
                                      Icons.check,
                                      size: 28,
                                      color: Colors.green,
                                    ),
                                  ),
                          ],
                        );
                      }

                      return IconButton(
                        onPressed: () => _toggleEditMode(username),
                        icon: const Icon(Icons.edit_outlined, size: 30),
                      );
                    },
                  ),
          ],
        ),
        body: user == null
            ? const Center(child: Text("Not logged in"))
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>?;

                  final username = data?['username'] ?? 'Unknown';
                  final email = data?['email'] ?? '';
                  final bestRun = data?['bestRun'] ?? 0;
                  final totalRuns = data?['totalRuns'] ?? 0;
                  final friends = List<String>.from(data?['friends'] ?? []);
                  final totalRunTime = data?['totalRunTime'] ?? 0;
                  final totalSteps = data?['totalSteps'] ?? 0;
                  final distanceTravelled = data?['distanceTravelled'] ?? 0.0;
                  final totalCalories = data?['totalCalories'] ?? 0.0;

                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 18,),

                            Stack (
                              alignment: Alignment.bottomRight,
                              children: [
                                GestureDetector(
                                  onTap: _isEditing ? _changeProfilePicture : null,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey.shade400,
                                    ),

                                    child:
                                    _isUploadingPhoto ? const Center(child: CircularProgressIndicator())
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: _pendingImage != null ? Image.file(
                                        _pendingImage!,
                                        fit: BoxFit.cover,
                                        width: 200,
                                        height: 200,
                                      ) : MyProfileAvatar(
                                        profileUrl: data?['profilePicUrl'] as String?,
                                        size: 200,
                                      )
                                    )
                                  )
                                ),

                                if (_isEditing)
                                  Container(
                                    padding: const EdgeInsets.all(13),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20
                                    ),
                                  )
                              ],
                            ),

                            const SizedBox(height: 20),

                            // username text field in edit mode, plain text otherwise
                            _isEditing ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                              ),
                              child: TextField(
                                controller: _usernameController,
                                autofocus: true,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                decoration: InputDecoration(
                                  hintText: "Enter new username",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade100,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.blue.shade100,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            )
                                : Center(
                              child: Text(
                                username,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            Center(
                              child: Text(
                                email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                              ),
                            ),//email

                            const SizedBox(height: 25),

                            MyStatsList(
                              bestRun: bestRun,
                              totalRunTime: totalRunTime,
                              totalRuns: totalRuns,
                              friends: friends.length,
                              totalSteps: totalSteps,
                              totalDistance: distanceTravelled,
                              totalCalories: totalCalories,
                            ),
                          ],
                        ),
                      ],
                    )
                  );
                },
              ),
      ),
    );
  }
}
