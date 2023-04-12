// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
//
// // Create a Google Maps widget.
// class WorkerMap extends StatefulWidget {
//   const WorkerMap({Key? key}) : super(key: key);
//
//   @override
//   State<WorkerMap> createState() => WorkerMapState();
// }
//
// class WorkerMapState extends State<WorkerMap> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   Set<Marker> _markers = {};
//
//   static const CameraPosition dublin = CameraPosition(
//     target: LatLng(53.3458, -6.2543577),
//     zoom: 14,
//   );
//
//   Future<Position> getUserCurrentLocation() async {
//     await Geolocator.requestPermission().then((value) {}).onError(
//       (error, stackTrace) async {
//         await Geolocator.requestPermission();
//         print("ERROR$error");
//       },
//     );
//     Position position = await Geolocator.getCurrentPosition();
//
//     // Call loadData() here to update the markers every time the user's location changes
//     loadData(position);
//
//     return position;
//   }
//
//   Set<Polyline> _polyline = {};
//
//   loadData(Position position) async {
//     //clear existing markers first
//     _markers.clear();
//
//     _markers.add(
//       Marker(
//         markerId: MarkerId('1'),
//         position: LatLng(position.latitude, position.longitude),
//         infoWindow: InfoWindow(
//           title: 'My Position',
//         ),
//       ),
//     );
//     final double radius = 100; // Define the radius of the polyline (in meters)
//     List<LatLng> polylineLatLngs = [];
//
// // Generate points for the polyline by drawing a circle around the marker position
//     for (var i = 0; i < 360; i += 10) {
//       double lat = position.latitude + radius * cos(i * pi / 180.0) / 111319.9;
//       double lng = position.longitude + radius * sin(i * pi / 180.0) / (111319.9 * cos(position.latitude * pi / 180.0));
//       polylineLatLngs.add(LatLng(lat, lng));
//     }
//
// // Draw the polyline on the map
//     _polyline.clear();
//     _polyline.add(
//       Polyline(
//         polylineId: PolylineId('circle'),
//         points: polylineLatLngs,
//         color: Colors.blue,
//         width: 2,
//       ),
//     );
//
//     setState(() {});
//   }
//
//   // static const CameraPosition trinity = CameraPosition(
//   //     bearing: 50, target: LatLng(53.359853, -6.266769), tilt: 40, zoom: 18);
//   //
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Theme(
//             data: ThemeData.from(
//               colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
//             ),
//             child: Scaffold(
//               body: GoogleMap(
//                 mapType: MapType.normal,
//                 initialCameraPosition: dublin,
//                 markers: Set<Marker>.of(_markers),
//                 polylines: Set<Polyline>.of(_polyline),
//                 myLocationEnabled: true,
//                 compassEnabled: true,
//                 onMapCreated: (GoogleMapController controller) {
//                   _controller.complete(controller);
//                 },
//               ),
//               floatingActionButton: FloatingActionButton.extended(
//                 onPressed: getUserCurrentLocation,
//                 backgroundColor: Colors.black,
//                 foregroundColor: Colors.red,
//                 label: const Text(
//                   'Get Route',
//                 ),
//                 icon: const Icon(
//                   Icons.route_outlined,
//                   color: Colors.red,
//                 ),
//               ),
//               floatingActionButtonLocation:
//                   FloatingActionButtonLocation.centerFloat,
//             )));
//   }
//
//   // Future<void> _goToCollege() async {
//   //   final GoogleMapController controller = await _controller.future;
//   //   controller.animateCamera(CameraUpdate.newCameraPosition(dublin));
//   // }
// }
//
// //get current location and send it to the ischrone.
////////////////////////////////////////////////////////////////////////////////////////////////
// import 'dart:convert';
// import 'dart:io';
// import 'dart:js_util';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart';
// import 'package:flutter/services.dart';
// import 'package:open_route_service/open_route_service.dart';
// import '/services/api.dart';
// import '/services/authentication.dart';
// import '/screens/BusStops.dart';
// import 'package:http/http.dart' as http;
//
// // Create a Google Maps widget.
// class WorkerMap extends StatefulWidget {
//   const WorkerMap({Key? key}) : super(key: key);
//
//   @override
//   State<WorkerMap> createState() => WorkerMapState();
// }
//
// class WorkerMapState extends State<WorkerMap> {
//   final Completer<GoogleMapController> _controller =
//   Completer<GoogleMapController>();
//   Set<Marker> _markers = {};
//
//   static const CameraPosition dublin = CameraPosition(
//     target: LatLng(53.3458, -6.2543577),
//     zoom: 14,
//   );
//
//   Set<Polyline> _polyline = Set <Polyline>();
//   Set<Polygon> _polygon = Set <Polygon>();
//
//   // created list of locations to display polygon
//   List<LatLng> points = [
//     // LatLng(53.344740, -6.2584452),
//     // LatLng(53.337656, -6.256319),
//     // LatLng(53.3458, -6.254358),
//   ];
//
//   List<LatLng> routePoints = [
//     // LatLng(53.344740, -6.2584452),
//     // LatLng(53.337656, -6.256319),
//     // LatLng(53.3458, -6.254358),
//   ];
//
//   // final List<LatLng> _latLngList = <LatLng>[
//   //   LatLng(53.34143382, -6.251562178),
//   //   LatLng(53.31992266, -6.233092929),
//   //   LatLng(53.32019859, -6.233516844),
//   //   LatLng(53.34094273, -6.249945298),
//   //   LatLng(53.33936739, -6.252232409),
//   //   LatLng(53.34777958, -6.242395312),
//   //   LatLng(53.32835551, -6.228375428),
//   //   LatLng(53.36197541, -6.260427638),
//   //
//   // ];
//   //
//   void getdirections() async {
//     // Initialize the openrouteservice with your API key.
//     final OpenRouteService client = OpenRouteService(
//         apiKey: '5b3ce3597851110001cf62481a41962da766498d8ebd2fcda0ced7d5');
//
//
//
//     // Example coordinates to test between
//     const double startLat = 53.344740;
//     const double startLng = -6.2584452;
//     // double endLat = points[0].latitude;
//     // double endLng = points[0].longitude;
//     double endLat = 53.344750;
//     double endLng = -6.2584472;
//
//     print("endpoint");
//     print(points[0].latitude);
//     print(points[0].longitude);
//
//     // Form Route between coordinates
//     final List<ORSCoordinate> routeCoordinates = await client
//         .directionsRouteCoordsGet(
//       startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
//       endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
//     );
//
//     // Print the route coordinates
//     routeCoordinates.forEach(print);
//
//     // Map route coordinates to a list of LatLng (requires google_maps_flutter package)
//     // to be used in the Map route Polyline.
//     //final List<LatLng>
//     routePoints = routeCoordinates
//         .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
//         .toList();
//     print("this is routeCoordinates");
//     print(routePoints);
//
//     // Create Polyline (requires Material UI for Color)
//     final Polyline routePolyline = Polyline(
//       polylineId: PolylineId('route'),
//       visible: true,
//       points: routePoints,
//       color: Colors.red,
//       width: 4,
//     );
//
//   }
//
//   // getUserCurrentLocation() -
//   // This function retrieves the user's current location using the Geolocator package and returns a Position object.
//   // It may require unit testing to verify that the function can retrieve the user's location correctly and handle any
//   // errors that may occur during the process.
//   Future<Position> getUserCurrentLocation() async {
//     await Geolocator.requestPermission().then((value) {}).onError(
//           (error, stackTrace) async {
//         await Geolocator.requestPermission();
//         print("ERROR$error");
//       },
//     );
//     Position position = await Geolocator.getCurrentPosition();
//
//     // Call loadData() here to update the markers every time the user's location changes
//     loadData(position);
//
//     return position;
//   }
//
//   @override
//   void initState() {
//     getIcons();
//     super.initState();
//   }
//
//   //Calls the icon
//   BitmapDescriptor icon =
//   BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//
//   // getIcons() -
//   // This function loads the custom marker icon from an image file and updates the icon property in the state.
//   // It may require unit testing to verify that the correct icon is loaded and displayed.
//   getIcons() async {
//     var icon = await BitmapDescriptor.fromAssetImage(
//         ImageConfiguration(size: Size(50, 50)), "images/busstop.png");
//     setState(() {
//       this.icon = icon;
//     });
//   }
//
//   // loadData(Position position) -
//   // This function updates the _markers set with the user's current location and nearby bus stops based on a certain range.
//   // It may require unit testing to verify that the markers are correctly added and displayed on the map.
//   loadData(Position position) async {
//     // Clear existing markers first
//     _markers.clear();
//
//     // Add marker for user's current location
//     _markers.add(
//       Marker(
//         markerId: MarkerId('1'),
//         position: LatLng(position.latitude, position.longitude),
//         infoWindow: InfoWindow(
//           title: 'My Position',
//         ),
//       ),
//     );
//
//     // Add markers for bus stops within a certain range from user's current location
//     for (int i = 0; i < BusStops.latLngList.length; i++) {
//       double distance = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         BusStops.latLngList[i].latitude,
//         BusStops.latLngList[i].longitude,
//       );
//       if (distance <= 220) {
//         // Display only bus stops within 500 meters
//         _markers.add(
//           Marker(
//             markerId: MarkerId(i.toString()),
//             position: BusStops.latLngList[i],
//             icon: icon,
//             infoWindow: InfoWindow(
//               title: 'Bus Stop ${i + 1}',
//             ),
//           ),
//         );
//       }
//     }
//     // Call setState() to update the UI with the new markers
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     AuthenticationHelper authenticationHelper = AuthenticationHelper();
//     return MaterialApp(
//       home: Scaffold(
//         body: Container(
//           child: SafeArea(
//             child: GoogleMap(
//               initialCameraPosition: dublin,
//               polylines: _polyline,
//               polygons: _polygon,
//               markers: Set<Marker>.of(_markers),
//               mapType: MapType.normal,
//               myLocationEnabled: true,
//               compassEnabled: true,
//               onMapCreated: (GoogleMapController controller) {
//                 _controller.complete(controller);
//               },
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           foregroundColor: Colors.white,
//           backgroundColor: Colors.red,
//           onPressed: () async {
//             updateStats(authenticationHelper);
//             getdirections();
//             getUserCurrentLocation().then(
//                   (value) async {
//                 print("${value.latitude} ${value.longitude}");
//
//                 _polygon.add(
//                     Polygon(
//                       // given polygonId
//                       polygonId: PolygonId('1'),
//                       // initialize the list of points to display polygon
//                       points: points,
//                       // given color to polygon
//                       fillColor: Colors.redAccent.withOpacity(0.3),
//                       // given border color to polygon
//                       strokeColor: Colors.redAccent.withOpacity(0.00001),
//                       geodesic: true,
//                       // given width of border
//                       strokeWidth: 4,
//                     )
//                 );
//                 _markers.add(
//                   Marker(
//                     markerId: MarkerId("2"),
//                     position: LatLng(value.latitude, value.longitude),
//                     infoWindow: InfoWindow(
//                       title: 'My Current Location',
//                     ),
//                   ),
//                 );
//
//                 _polyline.add(
//                     Polyline(
//                       polylineId: PolylineId('route'),
//                       visible: true,
//                       points: routePoints,
//                       color: Colors.red,
//                       width: 4,
//                     )
//                 );
//                 CameraPosition cameraPosition = CameraPosition(
//                   target: LatLng(value.latitude, value.longitude),
//                   zoom: 16,
//                 );
//                 final GoogleMapController controller = await _controller.future;
//                 controller.animateCamera(
//                   CameraUpdate.newCameraPosition(cameraPosition),
//                 );
//                 setState(() {});
//               },
//             );
//           },
//           child: Icon(Icons.location_searching),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       ),
//     );
//   }
//
//
//
//   Future<void> updateStats(AuthenticationHelper authenticationHelper) async {
//     ApiHandler apiHandler = ApiHandler();
//     Response response = await apiHandler.callApi("aggregator_getp", http.Client());
//     if (response.statusCode == 201) {
//       Map responseJson = ApiHandler().getResponseAsMap(response);
//       print (responseJson);
//       List Isochrone = jsonDecode(responseJson["Isochrone"]);
//       print(Isochrone);
//       print(Isochrone[0]["lat"]);
//       List <LatLng> tempPoints = [];
//       for (int i = 0; i < Isochrone.length; i++) {
//         tempPoints.add(LatLng(Isochrone[i]["lat"], Isochrone[i]["lon"]));
//       }
//
//       setState(() => points = tempPoints);
//       print(points);
//       // statistics["IncidentType"] =
//       //     disasterCatToString(statistics["IncidentType"]);
//     }
//   }
//
// }

import 'dart:convert';
import 'dart:io';
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:open_route_service/open_route_service.dart';
import '/services/api.dart';
import '/services/authentication.dart';
import '/screens/BusStops.dart';
import 'package:http/http.dart' as http;

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

  Set<Polyline> _polyline = Set <Polyline>();
  Set<Polygon> _polygon = Set <Polygon>();

  // created list of locations to display polygon
  List<LatLng> points = [
    // LatLng(53.344740, -6.2584452),
    // LatLng(53.337656, -6.256319),
    // LatLng(53.3458, -6.254358),
  ];

  List<LatLng> routePoints = [
    // LatLng(53.344740, -6.2584452),
    // LatLng(53.337656, -6.256319),
    // LatLng(53.3458, -6.254358),
  ];

  // final List<LatLng> _latLngList = <LatLng>[
  //   LatLng(53.34143382, -6.251562178),
  //   LatLng(53.31992266, -6.233092929),
  //   LatLng(53.32019859, -6.233516844),
  //   LatLng(53.34094273, -6.249945298),
  //   LatLng(53.33936739, -6.252232409),
  //   LatLng(53.34777958, -6.242395312),
  //   LatLng(53.32835551, -6.228375428),
  //   LatLng(53.36197541, -6.260427638),
  //
  // ];
  //
  void getdirections() async {
    // Initialize the openrouteservice with your API key.
    final OpenRouteService client = OpenRouteService(
        apiKey: '5b3ce3597851110001cf62481a41962da766498d8ebd2fcda0ced7d5');



    // Example coordinates to test between
    const double startLat = 53.344740;
    const double startLng = -6.2584452;
    double endLat = points[0].latitude;
    double endLng = points[0].longitude;

    print("this is the endpoint");
    print(points[0].latitude);

    // const double endLat = 53.3458;
    // const double endLng = -6.2543577;

    // Form Route between coordinates
    final List<ORSCoordinate> routeCoordinates = await client
        .directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng),
      endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
    );

    // Print the route coordinates
    routeCoordinates.forEach(print);

    // Map route coordinates to a list of LatLng (requires google_maps_flutter package)
    // to be used in the Map route Polyline.
    //final List<LatLng>
    routePoints = routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();
    print("this is routeCoordinates");
    print(routePoints);

    // Create Polyline (requires Material UI for Color)
    final Polyline routePolyline = Polyline(
      polylineId: PolylineId('route'),
      visible: true,
      points: routePoints,
      color: Colors.red,
      width: 4,
    );

  }

  // getUserCurrentLocation() -
  // This function retrieves the user's current location using the Geolocator package and returns a Position object.
  // It may require unit testing to verify that the function can retrieve the user's location correctly and handle any
  // errors that may occur during the process.
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

  @override
  void initState() {
    getIcons();
    super.initState();
  }

  //Calls the icon
  BitmapDescriptor icon =
  BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  // getIcons() -
  // This function loads the custom marker icon from an image file and updates the icon property in the state.
  // It may require unit testing to verify that the correct icon is loaded and displayed.
  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50, 50)), "images/busstop.png");
    setState(() {
      this.icon = icon;
    });
  }

  // loadData(Position position) -
  // This function updates the _markers set with the user's current location and nearby bus stops based on a certain range.
  // It may require unit testing to verify that the markers are correctly added and displayed on the map.
  loadData(Position position) async {
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

    // Add markers for bus stops within a certain range from user's current location
    for (int i = 0; i < BusStops.latLngList.length; i++) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        BusStops.latLngList[i].latitude,
        BusStops.latLngList[i].longitude,
      );
      if (distance <= 220) {
        // Display only bus stops within 500 meters
        _markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: BusStops.latLngList[i],
            icon: icon,
            infoWindow: InfoWindow(
              title: 'Bus Stop ${i + 1}',
            ),
          ),
        );
      }
    }
    // Call setState() to update the UI with the new markers
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationHelper authenticationHelper = AuthenticationHelper();
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child: SafeArea(
            child: GoogleMap(
              initialCameraPosition: dublin,
              polylines: _polyline,
              polygons: _polygon,
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
          foregroundColor: Colors.white,
          backgroundColor: Colors.red,
          onPressed: () async {
            updateStats(authenticationHelper);
            // getdirections();
            getUserCurrentLocation().then(
                  (value) async {
                print("${value.latitude} ${value.longitude}");

                _polygon.add(
                    Polygon(
                      // given polygonId
                      polygonId: PolygonId('1'),
                      // initialize the list of points to display polygon
                      points: points,
                      // given color to polygon
                      fillColor: Colors.redAccent.withOpacity(0.3),
                      // given border color to polygon
                      strokeColor: Colors.redAccent.withOpacity(0.00001),
                      geodesic: true,
                      // given width of border
                      strokeWidth: 4,
                    )
                );
                _markers.add(
                  Marker(
                    markerId: MarkerId("2"),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: InfoWindow(
                      title: 'My Current Location',
                    ),
                  ),
                );

                _polyline.add(
                    Polyline(
                      polylineId: PolylineId('route'),
                      visible: true,
                      points: routePoints,
                      color: Colors.red,
                      width: 4,
                    )
                );
                CameraPosition cameraPosition = CameraPosition(
                  target: LatLng(value.latitude, value.longitude),
                  zoom: 16,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }



  Future<void> updateStats(AuthenticationHelper authenticationHelper) async {
    ApiHandler apiHandler = ApiHandler();
    Response response = await apiHandler.callApi("aggregator_getp", http.Client());
    if (response.statusCode == 201) {
      Map responseJson = ApiHandler().getResponseAsMap(response);
      print (responseJson);
      List Isochrone = jsonDecode(responseJson["Isochrone"]);
      print(Isochrone);
      print(Isochrone[0]["lat"]);
      List <LatLng> tempPoints = [];
      for (int i = 0; i < Isochrone.length; i++) {
        tempPoints.add(LatLng(Isochrone[i]["lat"], Isochrone[i]["lon"]));
      }

      setState(() => points = tempPoints);
      getdirections();
      print(points);
      // statistics["IncidentType"] =
      //     disasterCatToString(statistics["IncidentType"]);
    }
  }

}

