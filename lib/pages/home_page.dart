import 'package:flutter/material.dart';
import '../components/my_buttons.dart';
import '../components/my_scrollable_draggable_sheet.dart';
import '../components/my_drawer.dart';
import '../map/g_map.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final GlobalKey<GMapState> _mapKey = GlobalKey<GMapState>();
  double _sheetSize = 0.35;

  @override
  void initState() {
    super.initState();

    _sheetController.addListener(() {
      setState(() {
        _sheetSize = _sheetController.size;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonBottom = screenHeight * _sheetSize + 10;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Homepage Page'),
        actions: [  // ---> friends button
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/my_friends_page'),
            icon: Icon(Icons.people_alt_outlined),
            iconSize: 28,
          ),
        ],
      ),

      body: Stack(
        children: [
          // GOOGLE MAP
          GMap(key: _mapKey,),

          // RESET CAMERA POSITION BUTTON
          Positioned(
            right: 16,
            bottom:
              buttonBottom > screenHeight/2 //if button > halfScreen
              ? 10 : buttonBottom,          //then 10 else stick to sheet
            child: ResetLocationButton(
              onPressed: () {
                _mapKey.currentState?.resetCamera();
              }, // ---> reset camera position
            ),
          ),

          //DRAGGABLE SCROLLABLE SHEET
          MyScrollableDraggableSheet(  // ---> This is the Bottom draggable sheet
            controller: _sheetController
          ),

          //START-RUN BUTTON
          Positioned(
              bottom: 0, right: 0, left: 0,//bounds
              child: StartRunButton(
                onTap: () {},// ---> starts the run will link later
              )
          ),
        ],
      ),

      drawer: MyDrawer(), // ---> This is the top left menu Drawer
    );
  }
}