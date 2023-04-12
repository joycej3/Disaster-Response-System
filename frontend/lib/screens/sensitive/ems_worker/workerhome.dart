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
                    style: TextStyle(fontSize: 21),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    'Use this tool for obtaining routes into emergency zones '
                    'and for evacuating injured people to the necessary locations. View'
                    ' disaster zones for in the field decision making.',
                    style: TextStyle(fontSize: 21),
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: ElevatedButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Place Holder',
                            style: TextStyle(color: Colors.white)),
                        content: Text(
                          ':)',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.black,
                        //shadowColor: Colors.yellow,
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, 'Drive Ambulance'),
                            child: const Text('Drive Ambulance',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.red),
                    child: const Text('View Disaster Info'),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => AuthenticationHelper().signOut(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.red),
                  child: Text('Logout'),
                ),
              ],
            ))));
  }
}
