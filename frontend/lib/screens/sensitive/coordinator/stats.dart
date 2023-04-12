import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/suggestions.dart';
import 'package:flutter_frontend/services/authentication.dart';
import 'package:flutter_frontend/services/api.dart';
import 'package:http/http.dart';
import 'dart:math';

class Stats extends StatefulWidget {
  @override
  State<Stats> createState() => StatsPage();
}

class StatsPage extends State<Stats> {
  Map statistics = {
    "Location": "waiting",
    "Area": "waiting",
    "ReportCount": "waiting",
    "IncidentType": "waiting",
    "KnownInjury": "waiting"
  };

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationHelper authenticationHelper = AuthenticationHelper();
    if (statistics["Location"] == "waiting") {
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
                  DataCell(Text(statistics['Location'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Approximate Area',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.map)),
                  DataCell(Text(statistics['Area'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'No.of Reports',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.numbers)),
                  DataCell(Text(statistics['ReportCount'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Disaster Category',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.category)),
                  DataCell(Text(statistics['IncidentType'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
                DataRow(cells: [
                  DataCell(Text(
                    'Injury Count',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  )),
                  DataCell(Icon(Icons.person)),
                  DataCell(Text(statistics['KnownInjury'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18))),
                ]),
              ]),
          SizedBox(height: 30),
          Container(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(
                    'Refresh Statistics',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {Navigator.pop(context, 'Cancel')},
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
                              Navigator.pop(context, 'Dispatch'),
                              updateStats(authenticationHelper)
                            },
                        child: Icon(Icons.refresh, color: Colors.blue)),
                  ],
                ),
              ),
              child: const Text('Refresh',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ),
        ]))));
  }

  Future<void> updateStats(AuthenticationHelper authenticationHelper) async {
    Response response = await authenticationHelper.secureApi("aggregator_get");
    if (response.statusCode == 201) {
      Map responseJson = ApiHandler().getResponseAsMap(response);
      setState(() => statistics = responseJson);
      statistics["IncidentType"] =
          disasterCatToString(statistics["IncidentType"]);
    }
  }

  String disasterCatToString(String category) {
    if (category == "0") {
      return "Fire";
    } else if (category == "1") {
      return "Natural Disaster";
    } else if (category == "2") {
      return "Traffic Related";
    } else {
      return "Other";
    }
  }
}
