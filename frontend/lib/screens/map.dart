import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(54.99662876, -7.317866335),
    zoom: 15,
  );

  Future<void> _loadMarkerIcon() async {
    final ByteData byteData = await rootBundle.load('assets/bus_stop.png');
    final Uint8List bytes = byteData.buffer.asUint8List();
    _busStopIcon = BitmapDescriptor.fromBytes(bytes);
  }

  final List<LatLng> _latLngList = <LatLng>[    LatLng(54.00332631, -6.580525931),    LatLng(54.00284784, -6.594103687),    LatLng(54.00287836, -6.592104286),  ];

  BitmapDescriptor _busStopIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

   final List<Marker> _markers = <Marker>[];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError(
          (error, stackTrace) async {
        await Geolocator.requestPermission();
        print("ERROR" + error.toString());
      },
    );
    Position position = await Geolocator.getCurrentPosition();

    // Call loadData() here to update the markers every time the user's location changes
    loadData(position);

    return position;
  }

  loadData(Position position) {
    // Clear existing markers first
    _markers.clear();

    // Add marker for user's current location
    _markers.add(
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: 'My Position',
        ),
      ),
    );

    // Add markers for bus stops
    for (int i = 0; i < _latLngList.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: _latLngList[i],
          icon: _busStopIcon,
          infoWindow: InfoWindow(
            title: 'Bus Stop ${i + 1}',
          ),
        ),
      );
    }
    // Call setState() to update the UI with the new markers
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F9D58),
        title: Text("GFG"),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            initialCameraPosition: _kGoogle,
            markers: Set<Marker>.of(_markers),
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then(
                (value) async {
              print(value.latitude.toString() +
                  " " +
                  value.longitude.toString());

              _markers.add(
                Marker(
                  markerId: MarkerId("2"),
                  position: LatLng(value.latitude, value.longitude),
                  infoWindow: InfoWindow(
                    title: 'My Current Location',
                  ),
                ),
              );
              CameraPosition cameraPosition = CameraPosition(
                target: LatLng(value.latitude, value.longitude),
                zoom: 14,
              );

              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(
                CameraUpdate.newCameraPosition(cameraPosition),
              );
              setState(() {});
            },
          );
        },
        child: Icon(Icons.location_searching),
      ),
    );
  }
}
