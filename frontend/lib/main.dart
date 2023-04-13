import 'dart:async';
//import 'dart:html';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/home.dart';
import 'package:flutter_frontend/screens/map.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_size/window_size.dart';
import 'services/firebase_options.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_home.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (UniversalPlatform.isWindows) {
    setWindowTitle('Disaster Response System');
    setWindowMinSize(const Size(600, 950));
  }
  if (UniversalPlatform.isDesktop) {
    setWindowTitle('Disaster Response System');
    setWindowMinSize(const Size(600, 950));
  }
  if (UniversalPlatform.isMacOS) {
    setWindowTitle('Disaster Response System');
    setWindowMinSize(const Size(600, 950));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      //home: Coordinator(),
      //home: MapSample(),
      //home: WorkerPage(),
      //home: CoordinatorHome(),
      // home: WorkerPage(),
    );
  }
}
