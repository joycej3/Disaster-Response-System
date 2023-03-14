import 'dart:math';

import 'package:flutter_frontend/screens/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker_map.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/workerhome.dart';
import 'package:flutter_frontend/screens/custom_form.dart';
import 'package:flutter_frontend/screens/login.dart';
import 'package:flutter_frontend/screens/map.dart';

void main() {
  testWidgets('Coordinator Page Test: ', (tester) async {
    // Test code goes here.
    print('Coordinator Page testing in progress...');
    await tester.pumpWidget(Coordinator());
    //if a certain phrase can be found on the page, test passes
    final textFinder = find.text('EMS Home');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Worker Map Page Test', (tester) async {
    print('EMS Worker Map Page testing in progress...');
    await tester.pumpWidget(WorkerMap());
    final textFinder = find.text('To College!');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Worker Page Test', (tester) async {
    print('EMS Worker Page testing in progress...');
    await tester.pumpWidget(WorkerPage());
    final textFinder = find.text('EMS Worker UI');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Worker Home Page Test', (tester) async {
    print('EMS Worker Home Page testing in progress...');
    await tester.pumpWidget(WorkerHome());
    final textFinder = find.text('Place Holder');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Report Submission Page Test', (tester) async {
    print('Report Submission Page testing in progress...');
    await tester.pumpWidget(MyCustomForm());
    final textFinder = find.text('Submit');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Login Page Test', (tester) async {
    print('EMS Login Page testing in progress...');
    await tester.pumpWidget(LoginForm());
    final textFinder = find.text('Password');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Civ Map Page Test', (tester) async {
    print('Civ Map Page testing in progress...');
    await tester.pumpWidget(MapSample());
    final textFinder = find.text('To College!');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Home Page Test', (tester) async {
    print('Home Page testing in progress...');
    await tester.pumpWidget(Home());

    final textFinder = find.text('Disaster Response System 9000');
    expect(textFinder, findsOneWidget);
  });
}
