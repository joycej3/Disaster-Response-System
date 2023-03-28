import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_frontend/services/api.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

// /////////
// // Create a Form widget.
class CoordinatorOptions extends StatefulWidget {
  CoordinatorOptions({Key? key}) : super(key: key);

  @override
  CoordinatorOptionsState createState() => CoordinatorOptionsState();
}

//ambulance 12
//paramedics 120
//fireengines 21
//police 95
//firefighters 963

// Create a corresponding State class.
// This class holds data related to the form.
class CoordinatorOptionsState extends State<CoordinatorOptions> {
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                /*1*/
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*2*/
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Suggested Ambulance number: '
                        '\n'
                        'Please confirm/augment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.local_hospital,
                          color: Colors.black,
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text('3',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    // Container(
                    //   padding: const EdgeInsets.all(8),
                    //   child: TextField(

                    //     cursorColor: Colors.blue,
                    //   ),
                    // )
                  ],
                ),
              ),

              /// second suggestion
              Expanded(
                /*1*/
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*2*/
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Suggested Paramedics number: '
                        '\n'
                        'Please confirm/augment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.health_and_safety,
                          color: Colors.black,
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text('10',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),

              /// third suggestion
              Expanded(
                /*1*/
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*2*/
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Suggested Fire Engine number: '
                        '\n'
                        'Please confirm/augment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.fire_truck,
                          color: Colors.black,
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text('8',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),

              /// fourth option
              Expanded(
                /*1*/
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*2*/
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Suggested Police officers number: '
                        '\n'
                        'Please confirm/augment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.local_police,
                          color: Colors.black,
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text('70',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),

              /// fifth option
              Expanded(
                /*1*/
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*2*/
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text(
                        'Suggested Firefighters number: '
                        '\n'
                        'Please confirm/augment',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.fire_extinguisher,
                          color: Colors.black,
                        )),
                    Container(
                        padding: const EdgeInsets.all(8),
                        child: Text('11',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(
                    Icons.send,
                    color: Colors.blue,
                    size: 50,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Submit required EMS numbers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//////////