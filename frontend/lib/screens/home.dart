import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/login.dart';
import 'package:flutter_frontend/screens/custom_form.dart';
import 'package:flutter_frontend/screens/map.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    Widget textSection = Padding(
      padding: EdgeInsets.fromLTRB(32, 0, 32, 5),
      child: DataTable(
        columns: [
          DataColumn(
              label: Text(
            'Tab',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          )),
          DataColumn(
              label: Text(
            'Use Case',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
          ))
        ],
        rows: [
          DataRow(cells: [
            DataCell(Icon(Icons.home)),
            DataCell(Text('General Info'))
          ]),
          DataRow(cells: [
            DataCell(Icon(Icons.report)),
            DataCell(Text('Report Page'))
          ]),
          DataRow(cells: [
            DataCell(Icon(Icons.directions)),
            DataCell(Text('Route Page'))
          ]),
          DataRow(cells: [
            DataCell(Icon(Icons.login)),
            DataCell(Text('Login Page'))
          ]),
        ],
      ),
    );

    Widget textSection2 = const Padding(
      padding: EdgeInsets.fromLTRB(32, 0, 32, 5),
      child: Text('Use this app to report and get routes away from disasters.',
          softWrap: true,
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    );

    Widget homePage = ListView(
      children: [
        Image.asset(
          'images/disaster.png',
          width: 90,
          height: 150,
          fit: BoxFit.cover,
        ),
        textSection,
        textSection2,
      ],
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        title: 'Disaster Response System-9000',
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Disaster Response System-9000'),
              bottom: const TabBar(
                indicator: BoxDecoration(color: Colors.orange),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 10,
                tabs: [
                  Tab(icon: Icon(Icons.home)),
                  Tab(icon: Icon(Icons.report)),
                  Tab(icon: Icon(Icons.directions)),
                  Tab(icon: Icon(Icons.login)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                homePage,
                WorkerPage(),
                MapSample(),
                LoginForm(),
              ],
            ),
          ),
        ));
  }
}
