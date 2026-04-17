import 'package:flutter/material.dart';
import 'my_buttons.dart';

class MyScrollableDraggableSheet extends StatelessWidget{
  const MyScrollableDraggableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.35,   //initial start of the sheet
          minChildSize: 0.25,       //lowest length to drag to
          maxChildSize: 0.85,       //highest length to drag to
          snap: true,
          snapSizes: [0.35, 0.85],
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

                  //DRAGGING HANDLE
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

                  const SizedBox(height: 10),

                  /*
                  More UI stuff for player Info
                   */
                ],
              ),
            );
          }
        ),

        //START-RUN BUTTON
        Positioned(
            bottom: 0, right: 0, left: 0,//bounds
            child: StartRunButton(
              onTap: () {},// ---> starts the run will link later
            )
        ),
      ],
    );
  }
}