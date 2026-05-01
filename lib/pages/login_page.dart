import 'package:fit_ness_territory/components/my_buttons.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController getUserAcc = TextEditingController();  //for the account
  TextEditingController getUserPass = TextEditingController(); //for user password

  final AuthService _authService = AuthService(); // connects to firebase auth + firestore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Login Page'),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              //LOGO ICON
              Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),

              SizedBox(height: 10), //spacing

              //SUBTITLE
              Text(
                'Please login with you FitNess Territory\n'
                    'account to get started',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.inversePrimary
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10), //spacing

              //ACCOUNT TEXT FIELD
              SizedBox(
                height: 45,
                child: TextField(
                  controller: getUserAcc,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      hintText: "Username@email.com",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      )
                  ),
                ),
              ),

              SizedBox(height: 10), //spacing

              // password text
              SizedBox(
                height: 45,
                child: TextField(
                  controller: getUserPass,
                  obscureText: true, //hides the text
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                      )
                  ),
                ),
              ),

              SizedBox(height: 10), //spacing

              // login buttons
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    /*
                  The login and register will be linked to the database but
                  for now only the login works as it goes to the homePage
                   */
                    Expanded( // REGISTER BUTTON
                      child: ButtonTwo(
                          onTap: () async { //handles user signup using firebase
                            final user = await _authService.signUp(
                              getUserAcc.text.trim(),
                              getUserPass.text.trim(),
                              getUserAcc.text.trim(),
                            );

                            if (!mounted) return;

                            if (user !=null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Account Created")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Signup Failed")),
                              );
                            }
                          }, // ----> this goes to registering a new account
                          buttonIcon: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          )
                      ),
                    ),

                    SizedBox(width: 6), //spacing

                    Expanded( // login
                      child: ButtonTwo(
                          onTap: () async { //handles user login using firebase
                            final user = await _authService.login(
                              getUserAcc.text.trim(),
                              getUserPass.text.trim(),
                            );

                            if (!mounted) return;

                            if (user != null) {
                              Navigator.pushReplacementNamed(context, '/home_page');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Login Failed"))
                              );
                            }
                          },
                          buttonIcon: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          )
                      ),
                    ),
                  ]
              ),

              const Spacer(flex: 2),

            ],
          ),
        ),
      ),
    );
  }
}