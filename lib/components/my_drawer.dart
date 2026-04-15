import 'package:fit_ness_territory/components/my_list.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // DRAWER HEADER / LOGO ---> can change to something else
          Column(
            children: [
              DrawerHeader(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ),

              // MY PROFILE
              MyList(
                text: 'My Profile',
                icon: Icons.home_filled,

                onTap: () {
                  Navigator.pop(context);//pops the drawer when navigating back
                  Navigator.pushNamed(context, '/my_profile_page');
                },
              ),

              SizedBox(height: 10), //spacing

              // SCOREBOARD
              MyList(
                text: 'Scoreboard',
                icon: Icons.leaderboard,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/scoreboard_page');
                }
              ),

              SizedBox(height: 10), //spacing

              // SETTINGS
              MyList(
                text: 'Settings',
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings_page');
                }
              ),
            ],
          ),

          // LOGOUT
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: MyList(
              text: 'Logout',
              icon: Icons.exit_to_app,//pushReplaceNamed to prevent going back
              onTap: () => Navigator.pushReplacementNamed(context, '/login_page'),
            ),
          ),
        ],
      ),
    );
  }
}
