import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_map.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/big_red_button.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_options.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/stats.dart';

class CoordinatorHome extends StatefulWidget {
  CoordinatorHome({Key? key}) : super(key: key);

  @override
  CoordinatorHomeState createState() => CoordinatorHomeState();
}

class CoordinatorHomeState extends State<CoordinatorHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Text('Hello_WOrld'),
    ));
  }
}
