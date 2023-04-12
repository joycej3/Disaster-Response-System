import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

// Create a Google Maps widget.
class WorkerMap extends StatefulWidget {
  const WorkerMap({Key? key}) : super(key: key);

  @override
  State<WorkerMap> createState() => WorkerMapState();
}

class WorkerMapState extends State<WorkerMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};

  static const CameraPosition dublin = CameraPosition(
    target: LatLng(53.3458, -6.2543577),
    zoom: 14,
  );

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError(
      (error, stackTrace) async {
        await Geolocator.requestPermission();
        print("ERROR$error");
      },
    );
    Position position = await Geolocator.getCurrentPosition();

    // Call loadData() here to update the markers every time the user's location changes
    loadData(position);

    return position;
  }

  Set<Polyline> _polyline = {};

  loadData(Position position) async {
    //clear existing markers first
    _markers.clear();

    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'My Position',
        ),
      ),
    );
    final double radius = 100; // Define the radius of the polyline (in meters)
    List<LatLng> polylineLatLngs = [];

// Generate points for the polyline by drawing a circle around the marker position
    for (var i = 0; i < 360; i += 10) {
      double lat = position.latitude + radius * cos(i * pi / 180.0) / 111319.9;
      double lng = position.longitude + radius * sin(i * pi / 180.0) / (111319.9 * cos(position.latitude * pi / 180.0));
      polylineLatLngs.add(LatLng(lat, lng));
    }

// Draw the polyline on the map
    _polyline.clear();
    _polyline.add(
      Polyline(
        polylineId: PolylineId('circle'),
        points: polylineLatLngs,
        color: Colors.blue,
        width: 2,
      ),
    );

    setState(() {});
  }

  // static const CameraPosition trinity = CameraPosition(
  //     bearing: 50, target: LatLng(53.359853, -6.266769), tilt: 40, zoom: 18);
  //

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Theme(
            data: ThemeData.from(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
            ),
            child: Scaffold(
              body: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: dublin,
                markers: Set<Marker>.of(_markers),
                polylines: Set<Polyline>.of(_polyline),
                myLocationEnabled: true,
                compassEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: getUserCurrentLocation,
                backgroundColor: Colors.black,
                foregroundColor: Colors.red,
                label: const Text(
                  'Get Route',
                ),
                icon: const Icon(
                  Icons.route_outlined,
                  color: Colors.red,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            )));
  }

  // Future<void> _goToCollege() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(dublin));
  // }
}

//get current location and send it to the ischrone.
