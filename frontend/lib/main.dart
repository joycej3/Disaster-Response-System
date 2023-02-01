import 'package:flutter/material.dart';
import 'dart:io';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    setWindowTitle('Disaster Response System');
    setWindowMinSize(const Size(600, 950));
    setWindowMaxSize(const Size(600, 950));
  }

  runApp(const MyApp());
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
                  padding: const EdgeInsets.only(bottom: 8),
                  child: const Text(
                    'Disaster Response System',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                ),
                Text(
                  'Use App for safe evacuation',
                  style: TextStyle(
                    color: Colors.grey[500],
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
        //_buildButtonColumn(color, Icons.call, 'EMERGNECY SERVICES'),
        _buildButtonColumn(color, Icons.report, 'REPORT AN EVENT'),
        _buildButtonColumn(color, Icons.directions, 'EVACUATION ROUTES'),
      ],
    );

    Widget textSection = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Disasters are serious disruptions to '
        'the functioning of a community that exceed '
        'its capacity to cope using its own resources. '
        'Disasters can be caused by natural, man-made '
        'and technological hazards, as well as various '
        'factors that influence the exposure and vulnerability '
        'of a community. ',
        softWrap: true,
      ),
    );

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        title: 'Disaster Response System 9000',
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Disaster Response System 9000'),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.report)),
                  Tab(icon: Icon(Icons.directions))
                ],
              ),
            ),
            body: ListView(
              children: [
                Image.asset(
                  'images/disaster.png',
                  width: 100,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                titleSection,
                buttonSection,
                textSection,
              ],
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
