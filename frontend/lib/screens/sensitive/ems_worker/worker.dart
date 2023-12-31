import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker_map.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/workerhome.dart';

class WorkerPage extends StatefulWidget {
  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

class _WorkerPageState extends State<WorkerPage> {
  String textHolder = 'EMS Worker UI';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Theme(
            data: ThemeData.from(
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
            ),
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text(
                    'EMS Worker UI',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  bottom: const TabBar(
                    indicator: BoxDecoration(color: Colors.black),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 10,
                    tabs: [
                      Tab(
                          icon: Icon(
                        Icons.home,
                        color: Colors.red,
                      )),
                      Tab(
                          icon: Icon(
                        Icons.directions,
                        color: Colors.red,
                      )),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    WorkerHome(),
                    WorkerMap(),
                  ],
                ),
              ),
            )));
  }
}
