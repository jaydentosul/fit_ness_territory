import 'package:fit_ness_territory/components/my_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController getUserAcc = TextEditingController();  //for the account
  TextEditingController getUserPass = TextEditingController(); //for user password

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

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

              //ACCOUNT TEXT FIELD
              SizedBox(
                height: 45,
                child: TextField(
                  controller: getUserPass,
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
                      onTap: () {}, // ----> this goes to registering a new account
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

                  Expanded( // LOGIN BUTTON
                    child: ButtonTwo(
                        onTap: () => Navigator.pushNamed(context, '/home_page'),
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
            ],
          ),
        ),
      ),
    );
  }
}