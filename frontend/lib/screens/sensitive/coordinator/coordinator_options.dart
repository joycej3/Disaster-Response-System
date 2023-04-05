import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/api.dart';
import 'package:flutter_frontend/services/authentication.dart';
import 'package:http/http.dart';

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
String ambNum = '';

class CoordinatorOptionsState extends State<CoordinatorOptions> {
  final TextEditingController ambulanceController = TextEditingController();
  final TextEditingController paraController = TextEditingController();
  final TextEditingController fireEng = TextEditingController();
  final TextEditingController policeController = TextEditingController();
  final TextEditingController fightController = TextEditingController();
  Map suggestions = {
    "ambulances": "waiting",
    "paramedics": "waiting",
    "fire_engines": "waiting",
    "fire_fighters": "waiting",
    "police": "waiting"
  };

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    ambulanceController.dispose();
    paraController.dispose();
    fireEng.dispose();
    policeController.dispose();
    fightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationHelper authenticationHelper = AuthenticationHelper();
    if (suggestions["ambulances"] == "waiting") {
      updateSuggestions(authenticationHelper);
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Column(children: [
          Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              height: 40,
              width: 340,
              child: Text(
                'Please review ML Model Suggestions',
                style: TextStyle(fontSize: 18, color: Colors.black),
                //softWrap: true,
                textAlign: TextAlign.center,
              )),
          Text(
            "Emergency Description",
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 26),
          ),
          DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Category',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                DataColumn(label: Text('')),
                DataColumn(
                  label: Text(
                    'Suggestion',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Decision',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
              ],

              /// Rows of table
              rows: [
                DataRow(cells: [
                  DataCell(Text(
                    'Ambulance',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.emergency_sharp, color: Colors.black)),
                  DataCell(Text(suggestions["ambulances"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                  DataCell(
                    TextField(
                      style: TextStyle(color: Colors.blue),
                      controller: ambulanceController,
                      obscureText: false,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  )
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Paramedics',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.medical_services, color: Colors.black)),
                  DataCell(Text(suggestions["paramedics"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                  DataCell(
                    TextField(
                      style: TextStyle(color: Colors.blue),
                      controller: paraController,
                      obscureText: false,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Fire Engines',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.fire_truck, color: Colors.black)),
                  DataCell(Text(suggestions["fire_engines"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                  DataCell(
                    TextField(
                      style: TextStyle(color: Colors.blue),
                      controller: fireEng,
                      obscureText: false,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Police',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.local_police, color: Colors.black)),
                  DataCell(Text(suggestions["police"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                  DataCell(TextField(
                    style: TextStyle(color: Colors.blue),
                    controller: policeController,
                    obscureText: false,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Fire-Fighters',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.fire_hydrant_alt, color: Colors.black)),
                  DataCell(Text(suggestions["fire_fighters"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                  DataCell(
                    TextField(
                      style: TextStyle(color: Colors.blue),
                      controller: fightController,
                      obscureText: false,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ])
              ]),
          SizedBox(height: 30),
          Container(
              alignment: Alignment.bottomCenter,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      //title: const Text('Update Suggestions'),
                      content: Text('Refresh decision making system',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () => {
                            updateSuggestions(authenticationHelper),
                            Navigator.pop(context, 'Refresh')
                          },
                          child: Icon(
                            Icons.refresh,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('Refresh',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                ),
                SizedBox(
                  width: 40,
                  height: 10,
                ),
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Confirm/Cancel Decision'),
                      content: DataTable(columns: [
                        DataColumn(label: Text('Category')),
                        DataColumn(label: Text('Quantity'))
                      ], rows: [
                        DataRow(cells: [
                          DataCell(Text('Ambulances: ')),
                          DataCell(Text(ambulanceController.text))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Paramedics: ')),
                          DataCell(Text(paraController.text))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Fire Engines: ')),
                          DataCell(Text(fireEng.text))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Police: ')),
                          DataCell(Text(policeController.text))
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Fire-Fighters: ')),
                          DataCell(Text(fightController.text))
                        ])
                      ]),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, 'Change/Cancel'),
                          child: const Text(
                            'Change/Cancel',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Dispatch'),
                          child: const Text(
                            'Dispatch',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('View Options',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ]))
        ])));
  }

  Future<void> updateSuggestions(
      AuthenticationHelper authenticationHelper) async {
    Response response =
        await authenticationHelper.secureApi("get_suggestion", {"id": "1"});
    Map responseJson = ApiHandler().getResponseAsMap(response);
    setState(() => suggestions = responseJson);
  }
}
