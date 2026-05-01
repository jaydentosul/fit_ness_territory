import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_api_key.dart';

/*
THis is for the Google Map
 */

class GMap extends StatefulWidget
{
  const GMap
      ({
    super.key,
  });

  @override
  State<GMap> createState() => GMapState();
}

class GMapState extends State<GMap>
{
  static const _initialCameraPosition = CameraPosition
    (
    target: LatLng
      (
      -36.850202 - 0.001,
      174.767688,
    ),
    zoom: 11.8,
  );

  GoogleMapController? _googleMapController;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _territoryRecordsStream;

  String? _selectedTerritoryId;
  String? _selectedTerritoryName;

  bool _isTracking = false;
  bool _routesAreLoading = false;
  bool _territoryRecordsLoaded = false;

  final List<LatLng> _playerRunPath = [];

  final Map<String, List<LatLng>> _realTerritoryRoutes = {};

  // Stores territory records loaded from Firebase.
  final Map<String, TerritoryRecord> _territoryRecords = {};

  // These are only route definitions.
  // Owner and fastest time are NOT stored here.
  // Owner and fastest time are loaded from Firebase Firestore.
  final List<Territory> _territories = const
  [
    Territory
      (
      id: 'waitakere_ranges_track',
      name: 'Waitakere Ranges Track',
      startPoint: LatLng
        (
        -36.947900,
        174.542600,
      ),
      endPoint: LatLng
        (
        -36.947900,
        174.542600,
      ),
      waypoints:
      [
        LatLng(-36.944800, 174.548000),
        LatLng(-36.948600, 174.554000),
        LatLng(-36.954000, 174.553200),
        LatLng(-36.956800, 174.546800),
        LatLng(-36.953200, 174.540800),
      ],
      points:
      [
        LatLng(-36.947900, 174.542600),
        LatLng(-36.944800, 174.548000),
        LatLng(-36.948600, 174.554000),
        LatLng(-36.954000, 174.553200),
        LatLng(-36.956800, 174.546800),
        LatLng(-36.953200, 174.540800),
        LatLng(-36.947900, 174.542600),
      ],
    ),

    Territory
      (
      id: 'cornwall_park_one_tree_hill_track',
      name: 'Cornwall Park / One Tree Hill Track',
      startPoint: LatLng
        (
        -36.901000,
        174.783900,
      ),
      endPoint: LatLng
        (
        -36.901000,
        174.783900,
      ),
      waypoints:
      [
        LatLng(-36.897800, 174.786800),
        LatLng(-36.899600, 174.792000),
        LatLng(-36.904300, 174.793300),
        LatLng(-36.907400, 174.789200),
        LatLng(-36.905100, 174.783500),
      ],
      points:
      [
        LatLng(-36.901000, 174.783900),
        LatLng(-36.897800, 174.786800),
        LatLng(-36.899600, 174.792000),
        LatLng(-36.904300, 174.793300),
        LatLng(-36.907400, 174.789200),
        LatLng(-36.905100, 174.783500),
        LatLng(-36.901000, 174.783900),
      ],
    ),

    Territory
      (
      id: 'auckland_domain_track',
      name: 'Auckland Domain Track',
      startPoint: LatLng
        (
        -36.860900,
        174.776000,
      ),
      endPoint: LatLng
        (
        -36.860900,
        174.776000,
      ),
      waypoints:
      [
        LatLng(-36.858600, 174.777800),
        LatLng(-36.859300, 174.781900),
        LatLng(-36.862300, 174.783400),
        LatLng(-36.865000, 174.780400),
        LatLng(-36.863600, 174.776300),
      ],
      points:
      [
        LatLng(-36.860900, 174.776000),
        LatLng(-36.858600, 174.777800),
        LatLng(-36.859300, 174.781900),
        LatLng(-36.862300, 174.783400),
        LatLng(-36.865000, 174.780400),
        LatLng(-36.863600, 174.776300),
        LatLng(-36.860900, 174.776000),
      ],
    ),

    Territory
      (
      id: 'shakespear_regional_park_track',
      name: 'Shakespear Regional Park Track',
      startPoint: LatLng
        (
        -36.606700,
        174.824600,
      ),
      endPoint: LatLng
        (
        -36.606700,
        174.824600,
      ),
      waypoints:
      [
        LatLng(-36.603600, 174.826900),
        LatLng(-36.602800, 174.832300),
        LatLng(-36.607300, 174.836200),
        LatLng(-36.611900, 174.832400),
        LatLng(-36.611000, 174.825700),
      ],
      points:
      [
        LatLng(-36.606700, 174.824600),
        LatLng(-36.603600, 174.826900),
        LatLng(-36.602800, 174.832300),
        LatLng(-36.607300, 174.836200),
        LatLng(-36.611900, 174.832400),
        LatLng(-36.611000, 174.825700),
        LatLng(-36.606700, 174.824600),
      ],
    ),
  ];

  @override
  void initState()
  {
    super.initState();

    _listenToTerritoryRecords();
  }

  @override
  void dispose()
  {
    _territoryRecordsStream?.cancel();
    _positionStream?.cancel();
    _googleMapController?.dispose();
    super.dispose();
  }

  void resetCamera()
  {
    _googleMapController?.animateCamera
      (
      CameraUpdate.newCameraPosition
        (
        _initialCameraPosition,
      ),
    );
  }

  void _showTopMessage(String message)
  {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar
      (
      SnackBar
        (
        content: Text
          (
          message,
          textAlign: TextAlign.center,
          style: const TextStyle
            (
            fontWeight: FontWeight.bold,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration
          (
          seconds: 2,
        ),
        margin: const EdgeInsets.only
          (
          left: 16,
          right: 16,
          top: 80,
          bottom: 735,
        ),
        shape: RoundedRectangleBorder
          (
          borderRadius: BorderRadius.circular
            (
            14,
          ),
        ),
      ),
    );
  }

  void _listenToTerritoryRecords()
  {
    _territoryRecordsStream = FirebaseFirestore.instance
        .collection
      (
      'territories',
    )
        .snapshots()
        .listen
      (
          (snapshot)
      {
        final Map<String, TerritoryRecord> loadedRecords = {};

        for (final doc in snapshot.docs)
        {
          final data = doc.data();

          loadedRecords[doc.id] = TerritoryRecord.fromFirestore
            (
            data,
          );
        }

        if (!mounted)
        {
          return;
        }

        setState
          (
              ()
          {
            _territoryRecordsLoaded = true;
            _territoryRecords.clear();
            _territoryRecords.addAll
              (
              loadedRecords,
            );
          },
        );
      },
      onError: (error)
      {
        debugPrint
          (
          'Could not load territory records: $error',
        );

        if (!mounted)
        {
          return;
        }

        setState
          (
              ()
          {
            _territoryRecordsLoaded = true;
          },
        );
      },
    );
  }

  String _formatDuration(Duration? time)
  {
    if (time == null)
    {
      return 'No record yet';
    }

    if (time == Duration.zero)
    {
      return 'No record yet';
    }

    final int minutes = time.inMinutes;
    final int seconds = time.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  TerritoryRecord? _getTerritoryRecord(Territory territory)
  {
    return _territoryRecords[territory.id];
  }

  String _getCurrentOwnerText(Territory territory)
  {
    if (!_territoryRecordsLoaded)
    {
      return 'Loading...';
    }

    final TerritoryRecord? record = _getTerritoryRecord
      (
      territory,
    );

    if (record == null)
    {
      return 'No owner yet';
    }

    if (record.currentOwner.trim().isEmpty)
    {
      return 'No owner yet';
    }

    return record.currentOwner;
  }

  String _getFastestTimeText(Territory territory)
  {
    if (!_territoryRecordsLoaded)
    {
      return 'Loading...';
    }

    final TerritoryRecord? record = _getTerritoryRecord
      (
      territory,
    );

    if (record == null)
    {
      return 'No record yet';
    }

    return _formatDuration
      (
      record.fastestTime,
    );
  }

  Territory? _getSelectedTerritory()
  {
    if (_selectedTerritoryId == null)
    {
      return null;
    }

    for (final territory in _territories)
    {
      if (territory.id == _selectedTerritoryId)
      {
        return territory;
      }
    }

    return null;
  }

  List<LatLng> _getRoutePoints(Territory territory)
  {
    return _realTerritoryRoutes[territory.id] ?? territory.points;
  }

  void _selectTerritoryOnly(Territory territory)
  {
    setState
      (
          ()
      {
        _selectedTerritoryId = territory.id;
        _selectedTerritoryName = territory.name;
      },
    );
  }

  void _selectTerritory(Territory territory)
  {
    _selectTerritoryOnly
      (
      territory,
    );

    _zoomToRouteOverview
      (
      territory,
    );
  }

  void _openTerritoryDetails(Territory territory)
  {
    _selectTerritory
      (
      territory,
    );

    showModalBottomSheet
      (
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder
        (
        borderRadius: BorderRadius.vertical
          (
          top: Radius.circular
            (
            24,
          ),
        ),
      ),
      builder: (context)
      {
        return Padding
          (
          padding: const EdgeInsets.all
            (
            24,
          ),
          child: Column
            (
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Text
                (
                territory.name,
                style: const TextStyle
                  (
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox
                (
                height: 16,
              ),

              Row
                (
                children:
                [
                  const Icon
                    (
                    Icons.emoji_events,
                    color: Colors.orange,
                  ),

                  const SizedBox
                    (
                    width: 8,
                  ),

                  Expanded
                    (
                    child: Text
                      (
                      'Current Owner: ${_getCurrentOwnerText(territory)}',
                      style: const TextStyle
                        (
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox
                (
                height: 12,
              ),

              Row
                (
                children:
                [
                  const Icon
                    (
                    Icons.timer,
                    color: Colors.blue,
                  ),

                  const SizedBox
                    (
                    width: 8,
                  ),

                  Expanded
                    (
                    child: Text
                      (
                      'Fastest Time: ${_getFastestTimeText(territory)}',
                      style: const TextStyle
                        (
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox
                (
                height: 20,
              ),

              SizedBox
                (
                width: double.infinity,
                child: ElevatedButton
                  (
                  style: ElevatedButton.styleFrom
                    (
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric
                      (
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder
                      (
                      borderRadius: BorderRadius.circular
                        (
                        18,
                      ),
                    ),
                  ),
                  onPressed: ()
                  {
                    Navigator.pop
                      (
                      context,
                    );

                    _selectTerritoryOnly
                      (
                      territory,
                    );

                    _showTopMessage
                      (
                      '${territory.name} selected.',
                    );
                  },
                  child: const Text
                    (
                    'Select This Territory',
                    style: TextStyle
                      (
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _loadRealTerritoryRoutes() async
  {
    if (_routesAreLoading)
    {
      return;
    }

    _routesAreLoading = true;

    for (final territory in _territories)
    {
      try
      {
        final List<LatLng> route = await _getRealWalkingRoute
          (
          territory,
        );

        if (!mounted)
        {
          return;
        }

        setState
          (
              ()
          {
            _realTerritoryRoutes[territory.id] = route;
          },
        );
      }
      catch (error)
      {
        debugPrint
          (
          'Could not load route for ${territory.name}: $error',
        );
      }
    }

    _routesAreLoading = false;
  }

  Future<List<LatLng>> _getRealWalkingRoute(Territory territory) async
  {
    final String waypointText = territory.waypoints.map
      (
          (point)
      {
        return '${point.latitude},${point.longitude}';
      },
    ).join('|');

    final Uri uri = Uri.https
      (
      'maps.googleapis.com',
      '/maps/api/directions/json',
      {
        'origin': '${territory.startPoint.latitude},${territory.startPoint.longitude}',
        'destination': '${territory.endPoint.latitude},${territory.endPoint.longitude}',
        'waypoints': waypointText,
        'mode': 'walking',
        'key': googleDirectionsApiKey,
      },
    );

    final response = await Dio().getUri
      (
      uri,
    );

    final data = response.data;

    if (data['status'] != 'OK')
    {
      throw Exception
        (
        'Directions API error: ${data['status']}',
      );
    }

    final String encodedPolyline = data['routes'][0]['overview_polyline']['points'];

    final List<PointLatLng> decodedPoints = PolylinePoints().decodePolyline
      (
      encodedPolyline,
    );

    return decodedPoints.map
      (
          (point)
      {
        return LatLng
          (
          point.latitude,
          point.longitude,
        );
      },
    ).toList();
  }

  Future<bool> prepareRunFromSelectedTerritory() async
  {
    final Territory? selectedTerritory = _getSelectedTerritory();

    if (selectedTerritory == null)
    {
      _showTopMessage
        (
        'Please select a route first.',
      );

      return false;
    }

    await _zoomToStartingPoint
      (
      selectedTerritory,
    );

    if (!mounted)
    {
      return false;
    }

    final bool isReady = await _showReadyDialog
      (
      selectedTerritory,
    );

    if (!mounted)
    {
      return false;
    }

    if (!isReady)
    {
      _showTopMessage
        (
        'Run cancelled.',
      );

      return false;
    }

    final bool trackingStarted = await startTracking();

    if (!trackingStarted)
    {
      return false;
    }

    _showTopMessage
      (
      'Run started in ${selectedTerritory.name}.',
    );

    return true;
  }

  Future<bool> startTracking() async
  {
    final bool hasPermission = await _checkLocationPermission();

    if (!hasPermission)
    {
      return false;
    }

    await _positionStream?.cancel();

    setState
      (
          ()
      {
        _isTracking = true;
        _playerRunPath.clear();
      },
    );

    const LocationSettings locationSettings = LocationSettings
      (
      accuracy: LocationAccuracy.high,
      distanceFilter: 3,
    );

    _positionStream = Geolocator.getPositionStream
      (
      locationSettings: locationSettings,
    ).listen
      (
          (Position position)
      {
        final LatLng newPosition = LatLng
          (
          position.latitude,
          position.longitude,
        );

        setState
          (
              ()
          {
            _playerRunPath.add
              (
              newPosition,
            );
          },
        );

        _googleMapController?.animateCamera
          (
          CameraUpdate.newLatLng
            (
            newPosition,
          ),
        );
      },
    );

    return true;
  }

  void pauseTracking()
  {
    _positionStream?.pause();

    setState
      (
          ()
      {
        _isTracking = false;
      },
    );
  }

  void resumeTracking()
  {
    _positionStream?.resume();

    setState
      (
          ()
      {
        _isTracking = true;
      },
    );
  }

  void stopTracking()
  {
    _positionStream?.cancel();
    _positionStream = null;

    setState
      (
          ()
      {
        _isTracking = false;
        _playerRunPath.clear();
      },
    );
  }

  Future<bool> _checkLocationPermission() async
  {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled)
    {
      if (!mounted)
      {
        return false;
      }

      _showTopMessage
        (
        'Please turn on location services.',
      );

      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied)
    {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied)
      {
        if (!mounted)
        {
          return false;
        }

        _showTopMessage
          (
          'Location permission was denied.',
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever)
    {
      if (!mounted)
      {
        return false;
      }

      _showTopMessage
        (
        'Location permission is permanently denied.',
      );

      return false;
    }

    return true;
  }

  Future<void> _zoomToRouteOverview(Territory territory) async
  {
    final List<LatLng> routePoints = _getRoutePoints
      (
      territory,
    );

    double minLat = routePoints.first.latitude;
    double maxLat = routePoints.first.latitude;
    double minLng = routePoints.first.longitude;
    double maxLng = routePoints.first.longitude;

    for (final point in routePoints)
    {
      if (point.latitude < minLat)
      {
        minLat = point.latitude;
      }

      if (point.latitude > maxLat)
      {
        maxLat = point.latitude;
      }

      if (point.longitude < minLng)
      {
        minLng = point.longitude;
      }

      if (point.longitude > maxLng)
      {
        maxLng = point.longitude;
      }
    }

    final LatLngBounds bounds = LatLngBounds
      (
      southwest: LatLng
        (
        minLat,
        minLng,
      ),
      northeast: LatLng
        (
        maxLat,
        maxLng,
      ),
    );

    await _googleMapController?.animateCamera
      (
      CameraUpdate.newLatLngBounds
        (
        bounds,
        80,
      ),
    );
  }

  Future<void> _zoomToStartingPoint(Territory territory) async
  {
    await _googleMapController?.animateCamera
      (
      CameraUpdate.newCameraPosition
        (
        CameraPosition
          (
          target: territory.startPoint,
          zoom: 17.5,
        ),
      ),
    );
  }

  Future<bool> _showReadyDialog(Territory territory) async
  {
    final bool? result = await showDialog<bool>
      (
      context: context,
      barrierDismissible: false,
      builder: (dialogContext)
      {
        return AlertDialog
          (
          backgroundColor: Colors.white,
          title: const Text
            (
            'Ready to start?',
            style: TextStyle
              (
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text
            (
            'You are at the starting point for ${territory.name}. Are you ready to begin?',
            style: const TextStyle
              (
              color: Colors.black,
            ),
          ),
          actions:
          [
            ElevatedButton
              (
              style: ElevatedButton.styleFrom
                (
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric
                  (
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder
                  (
                  borderRadius: BorderRadius.circular
                    (
                    20,
                  ),
                ),
              ),
              onPressed: ()
              {
                Navigator.of(dialogContext).pop
                  (
                  false,
                );
              },
              child: const Text
                (
                'No',
                style: TextStyle
                  (
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ElevatedButton
              (
              style: ElevatedButton.styleFrom
                (
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric
                  (
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder
                  (
                  borderRadius: BorderRadius.circular
                    (
                    20,
                  ),
                ),
              ),
              onPressed: ()
              {
                Navigator.of(dialogContext).pop
                  (
                  true,
                );
              },
              child: const Text
                (
                'Yes',
                style: TextStyle
                  (
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  Set<Polyline> _getTerritoryPaths()
  {
    final Set<Polyline> paths = _territories.map
      (
          (territory)
      {
        final bool isSelected = territory.id == _selectedTerritoryId;

        return Polyline
          (
          polylineId: PolylineId
            (
            territory.id,
          ),
          points: _getRoutePoints
            (
            territory,
          ),
          consumeTapEvents: true,
          onTap: ()
          {
            _openTerritoryDetails
              (
              territory,
            );
          },
          width: isSelected ? 9 : 6,
          color: isSelected ? Colors.orange : Colors.blue,
          geodesic: false,
        );
      },
    ).toSet();

    if (_playerRunPath.isNotEmpty)
    {
      paths.add
        (
        Polyline
          (
          polylineId: const PolylineId
            (
            'player_live_run_path',
          ),
          points: _playerRunPath,
          width: 8,
          color: Colors.green,
          geodesic: false,
        ),
      );
    }

    return paths;
  }

  Set<Marker> _getTerritoryMarkers()
  {
    final Set<Marker> markers = {};

    for (final territory in _territories)
    {
      final bool isSelected = territory.id == _selectedTerritoryId;

      markers.add
        (
        Marker
          (
          markerId: MarkerId
            (
            '${territory.id}_start_marker',
          ),
          position: territory.startPoint,
          infoWindow: InfoWindow
            (
            title: territory.name,
            snippet: 'Starting position',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue
            (
            isSelected ? BitmapDescriptor.hueOrange : BitmapDescriptor.hueGreen,
          ),
          onTap: ()
          {
            _openTerritoryDetails
              (
              territory,
            );
          },
        ),
      );

      markers.add
        (
        Marker
          (
          markerId: MarkerId
            (
            '${territory.id}_finish_marker',
          ),
          position: territory.endPoint,
          infoWindow: InfoWindow
            (
            title: '${territory.name} Finish',
            snippet: 'Finish point',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue
            (
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    if (_playerRunPath.isNotEmpty)
    {
      markers.add
        (
        Marker
          (
          markerId: const MarkerId
            (
            'player_current_position',
          ),
          position: _playerRunPath.last,
          infoWindow: const InfoWindow
            (
            title: 'Your current position',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue
            (
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    return markers;
  }

  Future<void> saveCompletedTerritoryRun
      (
      {
        required Duration runTime,
        required String playerName,
      }
      ) async
  {
    final Territory? selectedTerritory = _getSelectedTerritory();

    if (selectedTerritory == null)
    {
      _showTopMessage
        (
        'No territory selected.',
      );

      return;
    }

    if (runTime == Duration.zero)
    {
      _showTopMessage
        (
        'Run time was too short to save.',
      );

      return;
    }

    final DocumentReference<Map<String, dynamic>> territoryRef =
    FirebaseFirestore.instance
        .collection
      (
      'territories',
    )
        .doc
      (
      selectedTerritory.id,
    );

    final DocumentSnapshot<Map<String, dynamic>> territorySnapshot =
    await territoryRef.get();

    final Map<String, dynamic>? territoryData = territorySnapshot.data();

    final int newRunSeconds = runTime.inSeconds;

    int currentFastestSeconds = 0;

    if (territoryData != null && territoryData['fastestTimeSeconds'] != null)
    {
      final dynamic fastestValue = territoryData['fastestTimeSeconds'];

      if (fastestValue is int)
      {
        currentFastestSeconds = fastestValue;
      }
      else if (fastestValue is double)
      {
        currentFastestSeconds = fastestValue.round();
      }
    }

    final bool hasNoRecord = currentFastestSeconds <= 0;

    final bool isNewFastest =
        hasNoRecord || newRunSeconds < currentFastestSeconds;

    if (isNewFastest)
    {
      await territoryRef.set
        (
        {
          'territoryName': selectedTerritory.name,
          'currentOwner': playerName,
          'fastestTimeSeconds': newRunSeconds,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions
          (
          merge: true,
        ),
      );

      _showTopMessage
        (
        'New King/Queen of ${selectedTerritory.name}!',
      );
    }
    else
    {
      _showTopMessage
        (
        'Run saved, but record was not beaten.',
      );
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Stack
      (
      children:
      [
        GoogleMap
          (
          initialCameraPosition: _initialCameraPosition,
          myLocationButtonEnabled: true,
          myLocationEnabled: _isTracking,
          zoomControlsEnabled: true,
          minMaxZoomPreference: const MinMaxZoomPreference
            (
            10,
            20,
          ),
          polylines: _getTerritoryPaths(),
          markers: _getTerritoryMarkers(),
          onMapCreated: (controller)
          {
            _googleMapController = controller;
            _loadRealTerritoryRoutes();
          },
        ),

        Positioned
          (
          left: 20,
          right: 20,
          bottom: 20,
          child: Container
            (
            padding: const EdgeInsets.all
              (
              16,
            ),
            decoration: BoxDecoration
              (
              color: Colors.white,
              borderRadius: BorderRadius.circular
                (
                18,
              ),
              boxShadow: const
              [
                BoxShadow
                  (
                  blurRadius: 8,
                  offset: Offset
                    (
                    0,
                    3,
                  ),
                  color: Colors.black26,
                ),
              ],
            ),
            child: Text
              (
              _selectedTerritoryName == null
                  ? 'Select a route to run'
                  : _isTracking
                  ? 'Tracking: $_selectedTerritoryName'
                  : 'Selected: $_selectedTerritoryName',
              textAlign: TextAlign.center,
              style: const TextStyle
                (
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TerritoryRecord
{
  final String currentOwner;
  final Duration? fastestTime;

  const TerritoryRecord
      ({
    required this.currentOwner,
    required this.fastestTime,
  });

  factory TerritoryRecord.fromFirestore(Map<String, dynamic> data)
  {
    final String owner = data['currentOwner'] ?? '';

    final dynamic fastestTimeValue = data['fastestTimeSeconds'];

    Duration? fastestTime;

    if (fastestTimeValue is int && fastestTimeValue > 0)
    {
      fastestTime = Duration
        (
        seconds: fastestTimeValue,
      );
    }
    else if (fastestTimeValue is double && fastestTimeValue > 0)
    {
      fastestTime = Duration
        (
        seconds: fastestTimeValue.round(),
      );
    }
    else
    {
      fastestTime = null;
    }

    return TerritoryRecord
      (
      currentOwner: owner,
      fastestTime: fastestTime,
    );
  }
}

class Territory
{
  final String id;
  final String name;
  final List<LatLng> points;
  final LatLng startPoint;
  final LatLng endPoint;
  final List<LatLng> waypoints;

  const Territory
      ({
    required this.id,
    required this.name,
    required this.points,
    required this.startPoint,
    required this.endPoint,
    required this.waypoints,
  });
}