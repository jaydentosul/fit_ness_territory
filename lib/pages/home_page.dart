import 'package:flutter/material.dart';
import '../components/my_bottom_sheet.dart';
import '../components/my_drawer.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Homepage Page'),
      ),

      body: Stack(
        children: [
          //for the map
          Container(
            color: Colors.grey,
            child: Center(child: Text('This is for the Map\n'
                'fingers crossed')),
          ),

          const MyBottomSheet(),  // ---> This is the Bottom draggable sheet
        ],

      ),
      drawer: MyDrawer(), // ---> This is the top left menu Drawer
    );
  }
}