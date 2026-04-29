import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  String? _selectedTerritoryId;
  String? _selectedTerritoryName;

  // These are the territories the players can choose from.
  // The points are connected together to show the route the user should run.
  // These routes are spread across Auckland to avoid overlapping.

  final List<Territory> _territories = const
  [
    Territory
      (
      id: 'ponsonby_loop',
      name: 'Ponsonby Loop',
      startPoint: LatLng
        (
        -36.850600,
        174.742600,
      ),
      points:
      [
        LatLng(-36.850600, 174.742600),
        LatLng(-36.848900, 174.742900),
        LatLng(-36.847500, 174.744200),
        LatLng(-36.846700, 174.746200),
        LatLng(-36.847400, 174.748300),
        LatLng(-36.849500, 174.749100),
        LatLng(-36.851500, 174.748100),
        LatLng(-36.852100, 174.745700),
        LatLng(-36.850600, 174.742600),
      ],
    ),

    Territory
      (
      id: 'viaduct_harbour_loop',
      name: 'Viaduct Harbour Loop',
      startPoint: LatLng
        (
        -36.843300,
        174.756600,
      ),
      points:
      [
        LatLng(-36.843300, 174.756600),
        LatLng(-36.841800, 174.757200),
        LatLng(-36.841000, 174.759200),
        LatLng(-36.841200, 174.761700),
        LatLng(-36.842600, 174.763400),
        LatLng(-36.844600, 174.763500),
        LatLng(-36.845400, 174.761400),
        LatLng(-36.844900, 174.758800),
        LatLng(-36.843300, 174.756600),
      ],
    ),

    Territory
      (
      id: 'queen_street_cbd_loop',
      name: 'Queen Street CBD Loop',
      startPoint: LatLng
        (
        -36.849200,
        174.764900,
      ),
      points:
      [
        LatLng(-36.849200, 174.764900),
        LatLng(-36.848400, 174.766000),
        LatLng(-36.848500, 174.767600),
        LatLng(-36.849700, 174.768700),
        LatLng(-36.851200, 174.768300),
        LatLng(-36.852000, 174.766800),
        LatLng(-36.851400, 174.765200),
        LatLng(-36.849900, 174.764500),
        LatLng(-36.849200, 174.764900),
      ],
    ),

    Territory
      (
      id: 'auckland_domain_loop',
      name: 'Auckland Domain Loop',
      startPoint: LatLng
        (
        -36.861300,
        174.775000,
      ),
      points:
      [
        LatLng(-36.861300, 174.775000),
        LatLng(-36.859300, 174.776300),
        LatLng(-36.858500, 174.778900),
        LatLng(-36.859400, 174.781400),
        LatLng(-36.861700, 174.782600),
        LatLng(-36.864000, 174.781500),
        LatLng(-36.865000, 174.778800),
        LatLng(-36.864000, 174.776200),
        LatLng(-36.861300, 174.775000),
      ],
    ),

    Territory
      (
      id: 'mission_bay_loop',
      name: 'Mission Bay Loop',
      startPoint: LatLng
        (
        -36.848800,
        174.831900,
      ),
      points:
      [
        LatLng(-36.848800, 174.831900),
        LatLng(-36.847900, 174.834000),
        LatLng(-36.848400, 174.836300),
        LatLng(-36.850100, 174.837700),
        LatLng(-36.852100, 174.837100),
        LatLng(-36.853000, 174.834700),
        LatLng(-36.852300, 174.832400),
        LatLng(-36.850500, 174.831300),
        LatLng(-36.848800, 174.831900),
      ],
    ),

    Territory
      (
      id: 'mount_eden_loop',
      name: 'Mount Eden Loop',
      startPoint: LatLng
        (
        -36.876200,
        174.764600,
      ),
      points:
      [
        LatLng(-36.876200, 174.764600),
        LatLng(-36.874700, 174.766200),
        LatLng(-36.874600, 174.768700),
        LatLng(-36.876000, 174.770500),
        LatLng(-36.878300, 174.770700),
        LatLng(-36.880000, 174.768800),
        LatLng(-36.879900, 174.766000),
        LatLng(-36.878200, 174.764300),
        LatLng(-36.876200, 174.764600),
      ],
    ),

    Territory
      (
      id: 'western_springs_loop',
      name: 'Western Springs Loop',
      startPoint: LatLng
        (
        -36.868600,
        174.728300,
      ),
      points:
      [
        LatLng(-36.868600, 174.728300),
        LatLng(-36.866800, 174.730000),
        LatLng(-36.866400, 174.732700),
        LatLng(-36.867800, 174.735000),
        LatLng(-36.870300, 174.735400),
        LatLng(-36.872400, 174.733500),
        LatLng(-36.872600, 174.730600),
        LatLng(-36.870700, 174.728400),
        LatLng(-36.868600, 174.728300),
      ],
    ),

    Territory
      (
      id: 'one_tree_hill_loop',
      name: 'One Tree Hill Loop',
      startPoint: LatLng
        (
        -36.901300,
        174.783900,
      ),
      points:
      [
        LatLng(-36.901300, 174.783900),
        LatLng(-36.899300, 174.786000),
        LatLng(-36.899200, 174.789300),
        LatLng(-36.901300, 174.791500),
        LatLng(-36.904500, 174.791200),
        LatLng(-36.906400, 174.788500),
        LatLng(-36.905700, 174.785200),
        LatLng(-36.903300, 174.783500),
        LatLng(-36.901300, 174.783900),
      ],
    ),
  ];

  @override
  void dispose()
  {
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

  void _selectTerritory(Territory territory)
  {
    setState
      (
          ()
      {
        _selectedTerritoryId = territory.id;
        _selectedTerritoryName = territory.name;
      },
    );

    // When a user taps a territory path, the map zooms into that route.
    _zoomToSelectedTerritory
      (
      territory,
    );
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

    await _zoomToSelectedTerritory
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

    _showTopMessage
      (
      'Run started in ${selectedTerritory.name}.',
    );

    return true;
  }

  Future<void> _zoomToSelectedTerritory(Territory territory) async
  {
    double minLat = territory.points.first.latitude;
    double maxLat = territory.points.first.latitude;
    double minLng = territory.points.first.longitude;
    double maxLng = territory.points.first.longitude;

    for (final point in territory.points)
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
        70,
      ),
    );

    await Future.delayed
      (
      const Duration
        (
        milliseconds: 600,
      ),
    );

    await _googleMapController?.animateCamera
      (
      CameraUpdate.newCameraPosition
        (
        CameraPosition
          (
          target: territory.startPoint,
          zoom: 17.0,
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
    return _territories.map
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
          points: territory.points,

          // This lets the user tap the path to select the territory.
          consumeTapEvents: true,
          onTap: ()
          {
            _selectTerritory
              (
              territory,
            );
          },

          // Normal paths are blue.
          // The selected path becomes orange and thicker.
          width: isSelected ? 9 : 6,
          color: isSelected ? Colors.orange : Colors.blue,
          geodesic: false,
        );
      },
    ).toSet();
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
            _selectTerritory
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
          position: territory.points.last,
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

    return markers;
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
          myLocationButtonEnabled: false,
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

class Territory
{
  final String id;
  final String name;
  final List<LatLng> points;
  final LatLng startPoint;

  const Territory
      ({
        required this.id,
        required this.name,
        required this.points,
        required this.startPoint,
      });
}