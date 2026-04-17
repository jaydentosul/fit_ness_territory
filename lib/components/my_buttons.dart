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
class StartRunButton extends StatelessWidget{
  final void Function()? onTap;

  const StartRunButton({
    super.key,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: EdgeInsets.all(15),
      color: Theme.of(context).colorScheme.secondary,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(20)
          ),
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            'Start Run',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.green.shade600
            ),
          ),
        ),
      ),
    );
  }

}