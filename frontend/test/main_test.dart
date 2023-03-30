import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/screens/home.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker_map.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/workerhome.dart';
import 'package:flutter_frontend/screens/custom_form.dart';
import 'package:flutter_frontend/screens/login.dart';
import 'package:flutter_frontend/screens/map.dart';

void main() {
  testWidgets('Coordinator Page visual Test: ', (tester) async {
    // Test code goes here.
    print('Coordinator Page testing in progress...');
    await tester.pumpWidget(Coordinator());
    //if a certain phrase can be found on the page, test passes
    final textFinder = find.text('View options');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Worker Map Page visual Test', (tester) async {
    print('EMS Worker Map Page testing in progress...');
    await tester.pumpWidget(WorkerMap());
    final textFinder = find.text('Get Route');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Worker Page visual Test', (tester) async {
    print('EMS Worker Page testing in progress...');
    await tester.pumpWidget(WorkerPage());
    final textFinder = find.text('EMS Worker UI');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Worker Home Page visual Test', (tester) async {
    print('EMS Worker Home Page testing in progress...');
    await tester.pumpWidget(WorkerHome());
    final textFinder = find.text('Logout');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Report Submission Page visual Test', (tester) async {
    print('Report Submission Page testing in progress...');
    await tester.pumpWidget(MyCustomForm());
    final textFinder = find.text('Submit');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Login Page visual Test', (tester) async {
    print('EMS Login Page testing in progress...');
    await tester.pumpWidget(LoginForm());
    final textFinder = find.text('Password');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Civ Map Page visual Test', (tester) async {
    print('Civ Map Page testing in progress...');
    await tester.pumpWidget(MapSample());
    final textFinder = find.text('Get Route');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('Home Page visual Test', (tester) async {
    print('Home Page testing in progress...');
    await tester.pumpWidget(Home());

    final textFinder = find.text('Disaster Response System 9000');
    expect(textFinder, findsOneWidget);
  });
}
