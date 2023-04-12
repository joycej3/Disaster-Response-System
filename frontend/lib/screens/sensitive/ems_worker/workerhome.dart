import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/authentication.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator.dart';

class WorkerHome extends StatefulWidget {
  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.amber,
            body: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'EMS Worker Route Finder',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Use the map tab to obtain routes into emergency zones\n'
                    '\n'
                    'View disaster zone for in-the-field decision making.',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => AuthenticationHelper().signOut(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.red),
                  child: Container(
                      height: 40,
                      width: 100,
                      child: Text(
                        'Log Out',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      )),
                ),
              ],
            ))));
  }
}
