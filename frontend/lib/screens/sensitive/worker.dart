import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/authentication.dart';
// import 'package:flutter_frontend/screens/sensitive/home.dart';
import 'package:flutter_frontend/screens/custom_form.dart';

class WorkerPage extends StatefulWidget {
  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  String textHolder = 'Welcome to your mobile app';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Text(
                'Place Holder 2',
                style: TextStyle(fontSize: 21),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print("custom_form 2");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyCustomForm()));
                // MyCustomForm();
              }, //displaySecureResource(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black),
              child: const Text('Access_REST'),
            ),
            ElevatedButton(
              onPressed: () => AuthenticationHelper().signOut(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black),
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
