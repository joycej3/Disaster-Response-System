import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';

class Coordinator extends StatefulWidget {
  @override
  State<Coordinator> createState() => _CoordinatorHome();
}

class _CoordinatorHome extends State<Coordinator> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightBlue),
      ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.zero,
                child: Text(
                  'You are uncoordinated',
                  style: TextStyle(fontSize: 21),
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WorkerPage()));
                    WorkerPage();
                  }, //displaySecureResource(),
                  child: const Text('EMS Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
