import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';

import 'package:flutter_frontend/screens/sensitive/coordinator/suggestions.dart';

class Coordinator extends StatefulWidget {
  @override
  State<Coordinator> createState() => _CoordinatorHome();
}

class _CoordinatorHome extends State<Coordinator> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (CoordinatorPage()),
    );
  }
}
