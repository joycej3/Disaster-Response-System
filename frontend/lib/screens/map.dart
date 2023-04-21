import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:open_route_service/open_route_service.dart';
import '../services/api.dart';
import '../services/authentication.dart';
import 'BusStops.dart';
import 'package:http/http.dart' as http;

// Create a Google Maps widget.
class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  Set<Marker> _markers = {};

  static const CameraPosition dublin = CameraPosition(
    target: LatLng(53.3458, -6.2543577),
    zoom: 14,
  );

  Set<Polyline> _polyline = <Polyline>{};
  Set<Polygon> _polygon = <Polygon>{};

  // To check if point is inside or outside a polygon,
  // test how many times a ray, starting from the point and going in any fixed direction, intersects the
  // edges of the polygon. If the point is on the outside of the
  // polygon the ray will intersect its edge an even number of times.
  bool isPointInsidePolygon(LatLng point, List<LatLng> vertices) {
    int intersectCount = 0;
    for (int i = 0; i < vertices.length; i++) {
      LatLng vertex1 = vertices[i];
      LatLng vertex2 = vertices[(i + 1) % vertices.length];
      if (_rayCastIntersect(point, vertex1, vertex2)) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }

  bool _rayCastIntersect(LatLng point, LatLng vertex1, LatLng vertex2) {
    double lat1 = vertex1.latitude;
    double lng1 = vertex1.longitude;
    double lat2 = vertex2.latitude;
    double lng2 = vertex2.longitude;
    double lat = point.latitude;
    double lng = point.longitude;
    if ((lng1 > lng && lng2 > lng) || (lng1 < lng && lng2 < lng) ||
        (lat1 < lat && lat2 < lat)) {
      return false;
    }
    if (lng1 > lng && lng2 < lng) {
      double latIntersect =
          (lng - lng1) / (lng2 - lng1) * (lat2 - lat1) + lat1;
      if (latIntersect > lat) {
        return true;
      }
    } else if (lng1 < lng && lng2 > lng) {
      double latIntersect =
          (lng - lng1) / (lng2 - lng1) * (lat2 - lat1) + lat1;
      if (latIntersect > lat) {
        return true;
      }
    }
    return false;
  }


  List<LatLng> closestbusstops = [

  ];

  // created list of locations to display polygon
  List<LatLng> points = [
    LatLng(53.34248169, -6.255604373),
    LatLng(53.3520557, -6.233116005),
    LatLng(53.33947247, -6.250816458),
  ];

  List<LatLng> routePoints = [];
  Future<void> getdirections(Position position) async {
    // Initialize the openrouteservice with your API key.
    final OpenRouteService client = OpenRouteService(
        apiKey: '5b3ce3597851110001cf62481baa1779ac0d4d74b95dc014c636cf4f');

    // Use user's current location as start coordinate
    final double startLat = position.latitude;
    final double startLng = position.longitude;

    double shortestdist=10000000;
    double tempendLat=0;
    double tempendLng=0;
    List<LatLng> polypoints = points;
    polypoints.add(points[0]);
    for (int i = 0; i < closestbusstops.length; i++) {

      if (!isPointInsidePolygon(closestbusstops[i], polypoints ) ) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          closestbusstops[i].latitude,
          closestbusstops[i].longitude,
        );
        if (distance < shortestdist) {
          shortestdist = distance;
          tempendLat = closestbusstops[i].latitude;
          tempendLng = closestbusstops[i].longitude;
        }
      }
    }

    final double endLat= tempendLat;
    final double endLng = tempendLng;

    // Form Route between coordinates
    final List<ORSCoordinate> routeCoordinates =
    await client.directionsRouteCoordsGet(
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

    // Create Polyline (requires Material UI for Color)
    final Polyline routePolyline = Polyline(
      polylineId: PolylineId('route'),
      visible: true,
      points: routePoints,
      color: Colors.red,
      width: 4,
    );
    print("get directions returned");
    return;
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
    
    print("got position");
    // Call loadData() here to update the markers every time the user's location changes
    loadData(position);
    print("update bus stops");

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
      if (distance <= 600) {
        // Display only bus stops within 600 meters
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

        closestbusstops.add(BusStops.latLngList[i]);

      }
    }
    // Call setState() to update the UI with the new markers
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // AuthenticationHelper authenticationHelper = AuthenticationHelper();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            await getUserCurrentLocation().then(
                  (value) async {
                print("${value.latitude} ${value.longitude}");
                // ignore: await_only_futures
                await updateStats(AuthenticationHelper());
                await getdirections(value);
                
                print("getusercurrentlocation then returns");
                print("add iso polygon");
                _polygon.add(Polygon(
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
                ));
                print("add user marker");
                _markers.add(
                  Marker(
                    markerId: MarkerId("2"),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: InfoWindow(
                      title: 'My Current Location',
                    ),
                  ),
                );
                print("add route line");
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
                print("move camera");
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(cameraPosition),
                );
                print("setstate");
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


  //API request and its returning a lat and long for the isochrone
  Future<void> updateStats(AuthenticationHelper authenticationHelper) async {
    print("requesting polygon");
    ApiHandler apiHandler = ApiHandler();
    Response response =
        await apiHandler.callApi("aggregator_getp", http.Client());
    if (response.statusCode == 201) {
      Map responseJson = ApiHandler().getResponseAsMap(response);
      print(responseJson);
      List Isochrone = jsonDecode(responseJson["Isochrone"]);
      print(Isochrone);
      print(Isochrone[0]["lat"]);
      List<LatLng> tempPoints = [];
      for (int i = 0; i < Isochrone.length; i++) {
        tempPoints.add(LatLng(Isochrone[i]["lat"], Isochrone[i]["lon"]));
      }

      setState(() => points = tempPoints);
      print(points);
    }
  }
}
