import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/authentication.dart';
import 'package:flutter_frontend/screens/sensitive/worker.dart';

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
    String response =
        await AuthenticationHelper().extractTokenAndAccessSecureResource();
    setState(() {
      textHolder = response;
    });
  }
}
