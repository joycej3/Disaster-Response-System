import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/authentication.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator.dart';

class WorkerHome extends StatefulWidget {
  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
  String textHolder = 'Welcome to your mobile app';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.zero,
              child: Text(
                'Place Holder',
                style: TextStyle(fontSize: 21),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                'Use this tool for obtaining routes into emergency zones '
                'and for evacuating injured people to the necessary locations.',
                style: TextStyle(fontSize: 21),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              child: ElevatedButton(
                onPressed: () {
                  displaySecureResource();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Coordinator()));
                  Coordinator();
                }, //displaySecureResource(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, foregroundColor: Colors.red),
                child: const Text('Coordinator Page'),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => AuthenticationHelper().signOut(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.red),
              child: Text('Logout'),
            ),
          ],
        )));
  }

  displaySecureResource() async {
    String response = await AuthenticationHelper().secureApi("worker_get");
    setState(() {
      textHolder = response;
    });
  }
}
