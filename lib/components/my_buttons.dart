import 'package:fit_ness_territory/modes/modes.dart';
import 'package:flutter/material.dart';

//----------------------------- INTRO BUTTON ------------------------------------
class ButtonOne extends StatelessWidget{
  final void Function()? onTap;//on tap function
  final Widget buttonIcon; //for displaying the icon on the button

  const ButtonOne({
    super.key,
    required this.onTap,
    required this.buttonIcon
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(40, 13, 40, 13),
        child: buttonIcon,
      ),
    );
  }
}

//----------------------------- LOGIN BUTTONS ----------------------------------
class ButtonTwo extends StatelessWidget {
  final void Function()? onTap;//on tap function
  final Widget buttonIcon; //for displaying the icon on the button

  //constructor
  const ButtonTwo({
    super.key,
    required this.onTap,
    required this.buttonIcon
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.fromLTRB(40, 13, 40, 13),
        alignment: Alignment.center,
        child: buttonIcon,
      ),
    );
  }
}

//---------------------------- START-RUN BUTTON ------------------------------
class StartRunButton extends StatelessWidget {
  final RunState runState;
  final VoidCallback onTap;
  final Duration elapsed;

  const StartRunButton({
    super.key,
    required this.onTap,
    required this.runState,
    required this.elapsed,
  });

  //converting the duration to hr, min and sec
  String _formatTime(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hrs = twoDigits(d.inHours);
    final mins = twoDigits(d.inMinutes);
    final secs = twoDigits(d.inSeconds);

    return '$hrs:$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {

    //controlling the color & text
    Color buttonColor;
    String text;
    switch (runState) {
      case RunState.running:
        text = _formatTime(elapsed);
        buttonColor = Color(0xFF26BAA5);
        break;
      case RunState.idle:
        text = 'Start Run';
        buttonColor = Color(0xFF1FA327);
        break;
      default:
        text = 'Paused';
        buttonColor = Color(0xFF14329C);
    }

    return Container(
      width: double.infinity,
      height: 110,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 25),
      color: Theme.of(context).colorScheme.secondary,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(20)
          ),
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

//--------------------------- PAUSE & PLAY BUTTON ------------------------------
class PauseStopButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const PauseStopButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        color: Colors.black54,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

//--------------------------- RESET LOCATION BUTTON ----------------------------
class ResetLocationButton extends StatelessWidget{
  final VoidCallback onPressed;

  const ResetLocationButton({
    super.key,
    required this.onPressed,
  });


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: onPressed,
      child: Icon(Icons.my_location_outlined),
    );
  }

}