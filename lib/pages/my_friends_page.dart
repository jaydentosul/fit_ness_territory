import 'package:fit_ness_territory/components/my_profile_avatar.dart';
import 'package:fit_ness_territory/pages/view_friends_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/friend_service.dart';

/*
Add the friends sections here
 */

class MyFriendsPage extends StatefulWidget {
  const MyFriendsPage({super.key});

  @override
  State<MyFriendsPage> createState() => _MyFriendsPageState();
}

class _MyFriendsPageState extends State<MyFriendsPage> {
  final TextEditingController friendController = TextEditingController();

  String searchText = "";

  @override
  void dispose() {
    friendController.dispose();
    super.dispose();
  }

  // adds friend using the username typed in
  void addFriend(String username) async {
    await FriendService().addFriend(username);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Friend added")),
    );

    friendController.clear();

    setState(() {
      searchText = "";
    });
  }

  // deletes friend
  void deleteFriend(String username) async {
    await FriendService().deleteFriend(username);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Friend removed")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Friends'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(
            Icons.people_alt_outlined,
            size: 70,
            color: Colors.green,
          ),

          const SizedBox(height: 10),

          Center(
            child: Text(
              "Find Friends",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              "Search for users and add them to your friends list.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),

          const SizedBox(height: 25),

          TextField(
            controller: friendController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Search username",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value.trim();
              });
            },
          ),

          const SizedBox(height: 20),

          if (searchText.isEmpty)
            Center(
              child: Text(
                "Search for a username to add a friend",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),

          if (searchText.isNotEmpty)
            SizedBox(
              height: 120,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: searchText)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final users = snapshot.data!.docs;

                  if (users.isEmpty) {
                    return const Center(child: Text("No user found"));
                  }

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final data = user.data() as Map<String, dynamic>;

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: MyProfileAvatar(profileUrl: data['profilePicUrl'] as String?, size: 50),
                          title: Text(data['username'] ?? 'Unknown'),
                          subtitle: Text(data['email'] ?? ''),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () {
                              addFriend(data['username']);
                            },
                            child: const Text("Add"),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          const SizedBox(height: 25),

          Text(
            "My Friends",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),

          const SizedBox(height: 10),

          currentUser == null
              ? const Center(child: Text("Not logged in"))
              : StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final data =
              snapshot.data!.data() as Map<String, dynamic>?;

              final friends =
              List<String>.from(data?['friends'] ?? []);

              if (friends.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      "No friends added yet",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friendId = friends[index];

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(friendId)
                        .get(),
                    builder: (context, friendSnapshot) {
                      if (!friendSnapshot.hasData) {
                        return const ListTile(
                          leading: Icon(Icons.person),
                          title: Text("Loading friend..."),
                        );
                      }

                      final friendData = friendSnapshot.data!.data()
                      as Map<String, dynamic>?;

                      final username =
                          friendData?['username'] ?? 'Unknown';

                      final email = friendData?['email'] ?? '';

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewFriendPage(friendId: friendId),
                              ),
                            );
                          },
                          leading: MyProfileAvatar(
                              profileUrl: friendData?['profilePicUrl'] as String?,
                              size: 50
                          ),
                          title: Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(email),
                          trailing: IconButton(
                            onPressed: () {
                              deleteFriend(username);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
