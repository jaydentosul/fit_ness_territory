import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/my_buttons.dart';
import '../services/auth_service.dart';

/*
This is where the setting stuff goes
*/

// basic settings page
// might add more later
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage>{

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

      body: Column(
        children: [
          Expanded(
            child: ListView(
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
          ),

          // delete button pinned to bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: DeleteAccButton(
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Delete Account"),
                    content: const Text(
                      "Are you sure you want to delete your account",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirm != true) return;

                final success = await AuthService().deleteAccount();

                if (!mounted) return;

                if (success) {
                  Navigator.pushReplacementNamed(context, '/login_page');
                }
              },
              buttonIcon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Delete Account",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red.shade300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}