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

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser; //

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Friends Page'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: friendController,
              decoration: const InputDecoration(
                labelText: "Search username",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.trim();
                });
              },
            ),

            const SizedBox(height: 20),

            if (searchText.isEmpty)
              const Text("Search for a username to add a friend"),

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

                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(data['username'] ?? 'Unknown'),
                          subtitle: Text(data['email'] ?? ''),
                          trailing: ElevatedButton(
                            onPressed: () {
                              addFriend(data['username']);
                            },
                            child: const Text("Add Friend"),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            // shows current friends (maybe add remove button later?)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Friends",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: currentUser == null
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

                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  final friends = List<String>.from(data?['friends'] ?? []);

                  if (friends.isEmpty) {
                    return const Center(child: Text("No friends added yet"));
                  }

                  return ListView.builder(
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

                          final friendData =
                          friendSnapshot.data!.data() as Map<String, dynamic>?;

                          return ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(friendData?['username'] ?? 'Unknown'),
                            subtitle: Text(friendData?['email'] ?? ''),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}