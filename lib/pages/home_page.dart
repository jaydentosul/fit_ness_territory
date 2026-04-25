import 'package:fit_ness_territory/components/run_timer.dart';
import 'package:fit_ness_territory/modes/modes.dart';
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
  final RunTimer _runTimer = RunTimer();

  double _sheetSize = 0.35;
  RunState runState = RunState.idle;
  Duration elapsed = Duration.zero;
  Duration lastRun = Duration.zero;

  void _startRun() {
    if (runState == RunState.idle) {
      setState(() {
        runState = RunState.running;
        elapsed = Duration.zero; //starts timer
      });

      //resets and starts the timer
      _runTimer.reset();
      _runTimer.start((time) {
        setState(() {
          elapsed = time;
        });
      });
      
      _sheetController.animateTo( //animates the sheet when running
        0.25,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _pauseRun() {
    //Pausing
    if (runState == RunState.running) {
      _runTimer.pause();

      setState(() {
        runState = RunState.pause;
      });

    //Pressing play again
    } else if ( runState == RunState.pause) {
      setState(() {
        runState = RunState.running;
      });

      _runTimer.start((time) {
        setState(() {
          elapsed = time;
        });
      });

      _sheetController.animateTo( //animates the sheet when running
        0.25,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
// when run stops, we can save everything here (timer + later map data)
  void _stopRun() async {
    await _runTimer.saveRun(); // saves run time to firebase

    setState(() {
      lastRun = elapsed; // stores last run
      runState = RunState.idle;
    });

    _runTimer.reset();


    setState(() {
      elapsed = Duration.zero;
    });

    _sheetController.animateTo( //animates the sheet when running
      0.35,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _runTimer.pause();
    super.dispose();
  }

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
            controller: _sheetController,
            runState: runState,
            onStartRun: _startRun,
            onStopRun: _stopRun,
            onPauseRun: _pauseRun,
            elapsed: elapsed,
            lastRun: lastRun,
          ),

          //START-RUN BUTTON
          Positioned(
            bottom: 0, right: 0, left: 0,//bounds
            child: StartRunButton(
              onTap: _startRun,// ---> starts the run will link later
              runState: runState,
              elapsed: elapsed,
            ),
          ),
        ],
      ),

      drawer: MyDrawer(), // ---> This is the top left menu Drawer
    );
  }
}