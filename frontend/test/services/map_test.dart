
import 'package:flutter_frontend/screens/map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_frontend/screens/BusStops.dart';

void main() {
  group('loadData', () {
    test('location should be loaded', () {
      final map = MapSampleState();
      var pos = Position(longitude: -6.275608023504924, latitude: 53.336889383598674, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
      Set<Marker> _markers = {};
      final m =
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(pos.latitude, pos.longitude),
        infoWindow: InfoWindow(
          title: 'My Position',
        ),
      );
      _markers.add(
        m
      );
      //final pos =Position(longitude: -6.2543577, latitude: 53.3458, timestamp: position.timestamp, accuracy: position.accuracy, altitude: position.altitude, heading: position.heading, speed: position.speed, speedAccuracy: position.speedAccuracy);
     expect(_markers.contains(m), true);
    });

    test('closest bus stops should be loaded', () {

      var pos = Position(longitude: -6.275608023504924, latitude: 53.336889383598674, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
      // Add markers for bus stops within a certain range from user's current location
      Set<Marker> _markers = {};
      for (int i = 0; i < BusStops.latLngList.length; i++) {
        double distance = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          BusStops.latLngList[i].latitude,
          BusStops.latLngList[i].longitude,
        );
        if (distance <= 220) {
          // Display only bus stops within 100 meters
          _markers.add(
            Marker(
              markerId: MarkerId(i.toString()),
              position: BusStops.latLngList[i],
            ),
          );
        }
      }

      final m1 =
      Marker(
        markerId: MarkerId(1370.toString()),
        position: BusStops.latLngList[1370],
      );

      final m2=
      Marker(
        markerId: MarkerId(1286.toString()),
        position: BusStops.latLngList[1286],
      );



      expect(_markers.contains(m2), true);
      expect(_markers.contains(m1), true);
    });
  });
}

