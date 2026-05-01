import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
This is where the setting stuff goes
*/

// basic settings page
// might add more later
class SettingsPage extends StatelessWidget{
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Settings Page'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ACCOUNT SECTION
          const Text(
            "Account",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text("Email"),
            subtitle: Text(user?.email ?? "Not logged in"),
          ),

          const Divider(),

          // placeholder settings for future features
          const Text(
            "App Settings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text("Theme"),
            subtitle: const Text("Can be added later"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text("Notifications"),
            subtitle: const Text("Can be added later"),
            onTap: () {},
          ),

          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text("Privacy"),
            subtitle: const Text("Can be added later"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}