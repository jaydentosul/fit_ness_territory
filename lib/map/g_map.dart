import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
THis is for the Google Map
 */

class GMap extends StatefulWidget{
  const GMap({super.key});

  @override
  State<GMap> createState() => GMapState();

}

class GMapState extends State<GMap> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-36.850202, 174.767688),
    zoom: 12.5,
  );

  GoogleMapController? _googleMapController;

  @override
  void dispose() {
    _googleMapController?.dispose();
    super.dispose();
  }

  void resetCamera() {
    _googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(_initialCameraPosition),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
        ),
      ],
    );
  }

}