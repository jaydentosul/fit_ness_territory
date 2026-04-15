import 'package:flutter/material.dart';

class MyList extends StatelessWidget{
  final String text;
  final IconData icon;
  final double fontSize;
  final void Function()? onTap;

  const MyList({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey,
        ),
        title: Text(text),
        onTap: onTap,
      ),
    );
  }
}