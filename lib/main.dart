import 'package:fit_ness_territory/pages/home_page.dart';
import 'package:fit_ness_territory/pages/intro_page.dart';
import 'package:fit_ness_territory/pages/login_page.dart';
import 'package:fit_ness_territory/themes/my_themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),  //starts at the intro page when opening the app
      theme: myThemes,

      routes: {
        '/intro_page': (context) => const IntroPage(),
        '/login_page': (context) => const LoginPage(),
        '/home_page': (context) => const HomePage(),
      },

    );
  }
}

