import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'firebase_options.dart';
import 'package:flutter_frontend/screens/login/login.dart';
import 'package:flutter_frontend/screens/report_form/myCustomForm.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (UniversalPlatform.isWindows) {
    setWindowTitle('Disaster Response System');
    setWindowMinSize(const Size(600, 950));
    setWindowMaxSize(const Size(600, 950));
  }

  runApp(const MyApp());
}

// Create a Google Maps widget.
class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition Dublin = CameraPosition(
    target: LatLng(53.3458, -6.2543577),
    zoom: 14,
  );

  static const CameraPosition Trinity = CameraPosition(
      bearing: 50, target: LatLng(53.3447406, -6.2584452), tilt: 40, zoom: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: Dublin,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCollege,
        label: const Text('To College!'),
        icon: const Icon(Icons.school),
      ),
    );
  }

  Future<void> _goToCollege() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(Trinity));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // #docregion titleSection
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: const Text(
                    'Disaster Response System',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
                Text(
                  'Use App for safe evacuation',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Color color = Colors.red;

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        //_buildButtonColumn(color, Icons.call, 'EMERGENCY SERVICES'),
        _buildButtonColumn(color, Icons.report, 'REPORT AN EVENT'),
        _buildButtonColumn(color, Icons.directions, 'EVACUATION ROUTES'),
      ],
    );

    Widget textSection = const Padding(
      padding: EdgeInsets.fromLTRB(32, 0, 32, 5),
      child: Text(
        'Disasters are serious disruptions to '
        'the functioning of a community that exceed '
        'its capacity to cope using its own resources. '
        'Disasters can be caused by natural, man-made '
        'and technological hazards, as well as various '
        'factors that influence the exposure and vulnerability '
        'of a community. '
        '\n'
        '\n',
        softWrap: true,
      ),
    );

    Widget textSection2 = const Padding(
      padding: EdgeInsets.fromLTRB(32, 0, 32, 5),
      child: Text(
          'Please use this app to report and get routes away from disasters.',
          softWrap: true,
          style:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
    );

    Widget homePage = ListView(
      children: [
        Image.asset(
          'images/disaster.png',
          width: 100,
          height: 200,
          fit: BoxFit.cover,
        ),
        titleSection,
        textSection,
        textSection2,
        //buttonSection,
      ],
    );

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        title: 'Disaster Response System-9000',
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Disaster Response System 9000'),
              bottom: const TabBar(
                indicator: BoxDecoration(color: Colors.orangeAccent),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 10,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.report)),
                  Tab(icon: Icon(Icons.directions)),
                  Tab(icon: Icon(Icons.login)),
                ],
              ),
            ),
            // body: ListView(
            //   children: [
            //     Image.asset(
            //       'images/disaster.png',
            //       width: 100,
            //       height: 200,
            //       fit: BoxFit.cover,
            //     ),
            //     titleSection,
            //     buttonSection,
            //     textSection,
            //   ],
            body: TabBarView(
              children: [homePage, MyCustomForm(), MapSample(), LoginForm()],
            ),
          ),
        ));
  }
}

Column _buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color),
      Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    ],
  );
}
