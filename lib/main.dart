import 'package:fit_ness_territory/pages/home_page.dart';
import 'package:fit_ness_territory/pages/intro_page.dart';
import 'package:fit_ness_territory/pages/login_page.dart';
import 'package:fit_ness_territory/pages/my_friends_page.dart';
import 'package:fit_ness_territory/pages/my_profile_page.dart';
import 'package:fit_ness_territory/pages/scoreboard_page.dart';
import 'package:fit_ness_territory/pages/settings_page.dart';
import 'package:fit_ness_territory/pages/report_page.dart';
import 'package:fit_ness_territory/services/territory_setup_service.dart';
import 'package:fit_ness_territory/themes/my_themes.dart';
import 'package:fit_ness_territory/services/app_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await TerritorySetupService().initializeTerritories();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: AppSettingsService.themeMode,

      builder: (context, themeMode, child) {

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          // START PAGE
          home: const IntroPage(),

          // LIGHT MODE
          theme: myThemes,

          // DARK MODE
          darkTheme: myDarkTheme,

          // CURRENT THEME
          themeMode: themeMode,

          routes: {
            '/intro_page':      (context) => const IntroPage(),
            '/login_page':      (context) => const LoginPage(),
            '/home_page':       (context) => const HomePage(),
            '/my_profile_page': (context) => const MyProfilePage(),
            '/settings_page':   (context) => const SettingsPage(),
            '/scoreboard_page': (context) => const ScoreboardPage(),
            '/my_friends_page': (context) => const MyFriendsPage(),
            '/report_page':     (context) => const ReportPage(),
          },
        );
      },
    );
  }
}