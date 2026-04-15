import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{
  final void Function()? onTap;//on tap function
  final Widget buttonIcon; //for displaying the icon on the button

  const MyButton({
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
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
        child: buttonIcon,
      ),
    );
  }}