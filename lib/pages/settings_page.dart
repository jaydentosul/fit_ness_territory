import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/my_buttons.dart';
import '../services/auth_service.dart';
import '../services/app_settings_service.dart';

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

class _SettingsPage extends State<SettingsPage> {

  // sends password reset email
  Future<void> changePassword() async {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;

    if (email == null) return;

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset email sent")),
    );
  }

  // logs the user out
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login_page',
          (route) => false,
    );
  }

  // shows delete account popup
  Future<void> confirmDeleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "Are you sure you want to delete your account?",
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
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login_page',
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not delete account. Try logging in again."),
        ),
      );
    }
  }

  // reusable section title
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // reusable settings card
  Widget settingsCard(List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Settings Page'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ACCOUNT SECTION
          sectionTitle("Account"),

          settingsCard([
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text("Email"),
              subtitle: Text(user?.email ?? "Not logged in"),
            ),

            const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.password),
              title: const Text("Change Password"),
              subtitle: const Text("Send password reset email"),
              onTap: changePassword,
            ),

            const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              subtitle: const Text("Sign out of this account"),
              onTap: logout,
            ),
          ]),

          // APP SETTINGS SECTION
          sectionTitle("App Settings"),

          settingsCard([

            // dark mode setting
            ValueListenableBuilder(
              valueListenable: AppSettingsService.themeMode,
              builder: (context, themeMode, child) {
                return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text("Dark Mode"),
                  subtitle: const Text("Change app theme"),
                  value: themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    AppSettingsService.themeMode.value =
                    value ? ThemeMode.dark : ThemeMode.light;
                  },
                );
              },
            ),

            const Divider(height: 1),

            // notifications setting
            ValueListenableBuilder(
              valueListenable: AppSettingsService.notificationsOn,
              builder: (context, notificationsOn, child) {
                return SwitchListTile(
                  secondary: const Icon(Icons.notifications_none),
                  title: const Text("Notifications"),
                  subtitle: const Text("Turn notifications on/off"),
                  value: notificationsOn,
                  onChanged: (value) {
                    AppSettingsService.notificationsOn.value = value;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? "Notifications turned on"
                              : "Notifications turned off",
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const Divider(height: 1),

            // privacy setting
            ValueListenableBuilder(
              valueListenable: AppSettingsService.privateProfile,
              builder: (context, privateProfile, child) {
                return SwitchListTile(
                  secondary: const Icon(Icons.lock_outline),
                  title: const Text("Private Profile"),
                  subtitle: const Text("Hide profile from other users"),
                  value: privateProfile,
                  onChanged: (value) {
                    AppSettingsService.privateProfile.value = value;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          value
                              ? "Profile set to private"
                              : "Profile set to public",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ]),

          // DANGER SECTION
          sectionTitle("Danger Zone"),

          settingsCard([
            Padding(
              padding: const EdgeInsets.all(12),
              child: DeleteAccButton(
                onTap: confirmDeleteAccount,
                buttonIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}