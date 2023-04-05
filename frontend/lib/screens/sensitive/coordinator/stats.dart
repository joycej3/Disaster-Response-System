import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/suggestions.dart';
import 'package:flutter_frontend/services/authentication.dart';

import 'dart:math';

class Stats extends StatefulWidget {
  @override
  State<Stats> createState() => StatsPage();
}

Map statistics = {
    "location": "waiting",
    "ApproxArea": "waiting",
    "numReports": "waiting",
    "disCat": "waiting"
  };

class StatsPage extends State<Stats> {
    
  @override
  Widget build(BuildContext context) {
    AuthenticationHelper authenticationHelper = AuthenticationHelper();
    if (statistics["location"] == "waiting") {
      updateStats(authenticationHelper);
    }
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Scaffold(
                body: Column(children: [
          Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              height: 40,
              width: 340,
              child: Text(
                'Please view real-time disaster information',
                style: TextStyle(fontSize: 18, color: Colors.black),
                //softWrap: true,
                textAlign: TextAlign.center,
              )),
          Text(
            "Emergency Statistics",
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 26),
          ),
          DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Info',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ),
                DataColumn(label: Text('')),
                DataColumn(
                  label: Text(
                    '',
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
                    'Location',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.location_city)),
                  DataCell(Text('Fingal',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Approximate Area',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.map)),
                  DataCell(Text(statistics['ApproxArea'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'No.of Reports',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.numbers)),
                  DataCell(Text(statistics['numReports'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Disaster Category',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.category)),
                  DataCell(Text(statistics['disCat'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    '',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Text('')),
                  DataCell(Text('')),
                ]),
              ]),
          SizedBox(height: 30),
          Container(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Confirm/Cancel Decision'),
                  content: Text('Hello'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () =>
                          { 
                            Navigator.pop(context, 'Change/Cancel')},
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
              child: const Text('Refresh',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ]))));
  }
}

  Future<void> updateStats(
      AuthenticationHelper authenticationHelper) async {
    Response response =
        await authenticationHelper.secureApi("get_suggestion", {"id": "1"});
    Map responseJson = ApiHandler().getResponseAsMap(response);
    setState(() => statistics = responseJson);
  }
}
