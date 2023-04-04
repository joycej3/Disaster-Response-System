import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

// Create a Google Maps widget.
class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition dublin = CameraPosition(
    target: LatLng(53.3458, -6.2543577),
    zoom: 14,
  );

  static const CameraPosition trinity = CameraPosition(
      bearing: 50, target: LatLng(53.3447406, -6.2584452), tilt: 40, zoom: 18);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: dublin,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCollege,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: const Text('Get route'),
        icon: const Icon(Icons.directions),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }

  Future<void> _goToCollege() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(trinity));
  }
}
