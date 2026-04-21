import 'package:flutter/material.dart';

class MyBottomSheet extends StatelessWidget{
  const MyBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.10,//initial start of the sheet
      minChildSize: 0.02,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            )
          ),

          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.only(top: 10),
            children: [
              //drag handle
              Center(
                child: Container(
                  width: 55,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
              ),

              const SizedBox(height: 25),


              /*
              Can fill up this section with player stats as similar to
              the figma model
               */
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("Player Info",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10)
            ],
          ),
        );
      }
    );
  }
}