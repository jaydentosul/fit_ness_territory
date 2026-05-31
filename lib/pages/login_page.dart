import 'package:fit_ness_territory/components/my_buttons.dart';
import 'package:fit_ness_territory/services/territory_sync_service.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // account + password controllers
  TextEditingController getUserAcc = TextEditingController();
  TextEditingController getUserPass = TextEditingController();

  // gets username from email
  String getUserName(TextEditingController txtEdtC) {
    String email = txtEdtC.text.trim();
    return email.split('@').first;
  }

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: Center(
        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // LOGO
                Image.asset(
                  'assets/logo.png',
                  width: 110,
                  height: 110,
                ),

                const SizedBox(height: 20),

                // TITLE
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),

                const SizedBox(height: 8),

                // SUBTITLE
                Text(
                  'Login with your FitNess Territory account',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // EMAIL FIELD
                TextField(
                  controller: getUserAcc,

                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),

                  decoration: InputDecoration(
                    hintText: "Username@email.com",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),

                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // PASSWORD FIELD
                TextField(
                  controller: getUserPass,
                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),

                  decoration: InputDecoration(
                    hintText: "Password",

                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                    ),

                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                    ),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // BUTTONS
                Row(
                  children: [

                    // REGISTER BUTTON
                    Expanded(
                      child: ButtonTwo(
                        onTap: () async {

                          final user = await _authService.signUp(
                            getUserAcc.text.trim(),
                            getUserPass.text.trim(),
                            getUserName(getUserAcc),
                          );

                          if (!mounted) return;

                          if (user != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Account Created"),
                              ),
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Signup Failed"),
                              ),
                            );
                          }
                        },

                        buttonIcon: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // LOGIN BUTTON
                    Expanded(
                      child: ButtonTwo(
                        onTap: () async {

                          final user = await _authService.login(
                            getUserAcc.text.trim(),
                            getUserPass.text.trim(),
                          );

                          if (!mounted) return;

                          if (user != null) {

                            // sync territories before home page
                            await TerritorySyncService().syncTerritoryRecords();

                            Navigator.pushReplacementNamed(context, '/home_page',);

                          } else {

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Failed"),
                              ),
                            );
                          }
                        },

                        buttonIcon: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                GestureDetector(
                  onTap: () async {
                    final email = getUserAcc.text.trim();
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Enter your Email first"))
                      ); return;
                    }

                    await _authService.sendPasswordReset(email);
                    if(!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset email sent'))
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}