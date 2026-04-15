import 'package:fit_ness_territory/components/my_button.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo
            Image.asset(
              'assets/logo.png',
              width: 150,
              height: 150,
            ),

            SizedBox(height: 25), //for spacing

            //Title
            const Text(
              'FitNess Territory',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              )
            ),

            SizedBox(height: 10), //for spacing

            //Subtitle
            Text(
              'What the fuck is going on',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            SizedBox(height: 10), //for spacing

            //Button
            ButtonOne(
              onTap: () => Navigator.pushNamed(context, '/login_page'),
              buttonIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}
