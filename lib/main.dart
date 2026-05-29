import 'package:fit_ness_territory/pages/home_page.dart';
import 'package:fit_ness_territory/pages/intro_page.dart';
import 'package:fit_ness_territory/pages/login_page.dart';
import 'package:fit_ness_territory/pages/my_friends_page.dart';
import 'package:fit_ness_territory/pages/my_profile_page.dart';
import 'package:fit_ness_territory/pages/scoreboard_page.dart';
import 'package:fit_ness_territory/pages/settings_page.dart';
import 'package:fit_ness_territory/pages/report_page.dart';
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
          darkTheme: ThemeData.dark().copyWith(

            colorScheme: const ColorScheme.dark(
              surface: Color(0xFF121212),      // page background
              tertiary: Color(0xFF1E1E1E),     // cards / sheets
              inversePrimary: Colors.white,    // main text
              primary: Colors.green,           // accent colour
              secondary: Color(0xFF1E1E1E),    // input / card background
            ),

            scaffoldBackgroundColor: const Color(0xFF121212),

            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
            ),

            drawerTheme: const DrawerThemeData(
              backgroundColor: Color(0xFF121212),
            ),

            cardColor: const Color(0xFF1E1E1E),

            iconTheme: const IconThemeData(
              color: Colors.white70,
            ),

            listTileTheme: const ListTileThemeData(
              textColor: Colors.white,
              iconColor: Colors.white70,
            ),

            // GLOBAL TEXT COLOURS
            textTheme: const TextTheme(

              bodyLarge: TextStyle(
                color: Colors.white,
              ),

              bodyMedium: TextStyle(
                color: Colors.white70,
              ),

              bodySmall: TextStyle(
                color: Colors.white60,
              ),

              titleLarge: TextStyle(
                color: Colors.white,
              ),

              titleMedium: TextStyle(
                color: Colors.white70,
              ),

              titleSmall: TextStyle(
                color: Colors.white60,
              ),
            ),

            // TEXT FIELD DESIGN
            inputDecorationTheme: InputDecorationTheme(

              filled: true,
              fillColor: const Color(0xFF1E1E1E),

              hintStyle: TextStyle(
                color: Colors.grey.shade400,
              ),

              labelStyle: const TextStyle(
                color: Colors.white,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.grey.shade800,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Colors.green,
                  width: 1.5,
                ),
              ),
            ),

            // CURSOR COLOR
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.white,
            ),

            // BUTTON DESIGN
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

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