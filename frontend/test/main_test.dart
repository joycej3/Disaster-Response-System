import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_options.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/screens/home.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_home.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/big_red_button.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/worker.dart';
import 'package:flutter_frontend/screens/sensitive/ems_worker/workerhome.dart';
import 'package:flutter_frontend/screens/custom_form.dart';
import 'package:flutter_frontend/screens/login.dart';

void main() {
  //////  EMS WORKER PAGES TEST --- START ////
  testWidgets('EMS Worker Page Test', (tester) async {
    print('EMS Worker Page testing in progress...');
    await tester.pumpWidget(WorkerPage());
    final textFinder = find.text('EMS Worker UI');
    expect(textFinder, findsOneWidget);
  });

  testWidgets('EMS Worker Home Page Test', (tester) async {
    print('EMS Worker Home Page testing in progress...');
    await tester.pumpWidget(WorkerHome());
    final textFinder = find.text('Log Out');
    expect(textFinder, findsOneWidget);
  });
  ////// EMS WORKER PAGES TESTS ---- END ////

  ///

  ////// PUBLIC PAGES TEST --- START
  testWidgets('Home Page Test', (tester) async {
    print('Home Page testing in progress...');
    await tester.pumpWidget(Home());

    final textFinder = find.text('Login Page');
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
  ////// PUBLIC PAGES TESTS ---- END
}
