import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_frontend/services/api.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

// /////////
// // Create a Form widget.
class MyCustomForm extends StatefulWidget {
  MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

const List<String> emergencyCategories = <String>[
  'Choose an option...',
  'Natural Disaster',
  'Fire Related',
  'Traffic Related',
  'Aliens',
  'Other'
];

const List<String> injuryCategories = <String>[
  'Choose an option...',
  'I am not injured',
  'I am injured',
  'I can see injured people',
  'I have one leg hanging off'
];

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String _emrgencyCat = '';
  String _injuryCat = '';
  String inj_dropdownValue = injuryCategories.first;
  String cat_dropdownValue = emergencyCategories.first;

  @override
  Widget build(BuildContext context) {
    ApiHandler apiHandler = ApiHandler();

    // Build a Form widget using the _formKey created above.
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25),
              Text(
                "Emergency Description",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.red, width: 5)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.red, width: 5)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                  filled: true,
                  fillColor: Colors.redAccent,
                ),
                dropdownColor: Colors.redAccent,
                value: cat_dropdownValue,
                icon: const Icon(
                  Icons.arrow_downward,
                  color: Colors.white,
                ),
                elevation: 16,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (String? value) {
                  setState(() {
                    cat_dropdownValue = value!;
                  });
                },
                items: emergencyCategories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value == 'Choose an option...') {
                    return 'Please choose an option';
                  } else {
                    _emrgencyCat = value;
                    return null;
                  }
                },
              ),
              SizedBox(height: 40),
              Text(
                "Report Injuries",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
              SizedBox(height: 15),

              DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.red, width: 5)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.red, width: 5)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: Colors.red, width: 2)),
                    filled: true,
                    fillColor: Colors.redAccent,
                  ),
                  dropdownColor: Colors.redAccent,
                  value: inj_dropdownValue,
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: Colors.white,
                  ),
                  elevation: 16,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  onChanged: (String? value) {
                    setState(() {
                      inj_dropdownValue = value!;
                    });
                  },
                  items: injuryCategories
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value == 'Choose an option...') {
                      return 'Please choose an option';
                    } else {
                      _injuryCat = value;
                      return null;
                    }
                  }),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 3, color: Colors.red),
                      foregroundColor: Colors.white,
                      shadowColor: Colors.red,
                      backgroundColor: Colors.redAccent,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      fixedSize: Size(100, 50)),
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      DateTime time = DateTime.now();
                      Location location = new Location();

                      bool _serviceEnabled = await location.serviceEnabled();
                      if (!_serviceEnabled) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('await requestservice')),
                        );
                        _serviceEnabled = await location.requestService();
                        if (!_serviceEnabled) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Location services required to send report')),
                          );
                          return;
                        }
                      }

                      PermissionStatus _permissionGranted =
                          await location.hasPermission();
                      if (_permissionGranted == PermissionStatus.denied) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('await requestpermission')),
                        );
                        _permissionGranted = await location.requestPermission();
                        if (_permissionGranted != PermissionStatus.granted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Location permissions required to send report')),
                          );
                          return;
                        }
                      }

                      LocationData _locationData = await location.getLocation();
                      apiHandler.callApi("database_push", http.Client(), {
                        'emergency': _emrgencyCat,
                        'injury': _injuryCat,
                        'time': time.millisecondsSinceEpoch,
                        'lon': _locationData.longitude,
                        'lat': _locationData.latitude
                      });

                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report sent!')),
                      );
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
