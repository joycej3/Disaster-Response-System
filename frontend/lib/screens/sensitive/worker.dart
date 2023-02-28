import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/workerhome.dart';
import 'package:flutter_frontend/services/authentication.dart';
// import 'package:flutter_frontend/screens/sensitive/home.dart';
import 'package:flutter_frontend/screens/map.dart';

class WorkerPage extends StatefulWidget {
  @override
  State<WorkerPage> createState() => _WorkerPageState();
}

// class _WorkerPageState extends State<WorkerPage> {
//   String textHolder = 'Welcome to your mobile app';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.red,
//         body: Center(
//             child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
//               child: Text(
//                 textHolder,
//                 style: TextStyle(fontSize: 21),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 print("custom_form 2");
//                 displaySecureResource();
//                 // Navigator.push(context,
//                 //     MaterialPageRoute(builder: (context) => MyCustomForm()));
//                 // MyCustomForm();
//               }, //displaySecureResource(),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.yellow,
//                   foregroundColor: Colors.black),
//               child: const Text('Access_REST'),
//             ),
//             ElevatedButton(
//               onPressed: () => AuthenticationHelper().signOut(),
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.yellow,
//                   foregroundColor: Colors.black),
//               child: Text('Logout'),
//             ),
//           ],
//         )));
//   }

class _WorkerPageState extends State<WorkerPage> {
  String textHolder = 'EMS Worker UI';
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber),
        ),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('EMS Worker UI'),
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
                MapSample(),
              ],
            ),
          ),
        ));
    //   ElevatedButton(
    //     onPressed: () {
    //       print("custom_form 2");
    //       displaySecureResource();
    //       // Navigator.push(context,
    //       //     MaterialPageRoute(builder: (context) => MyCustomForm()));
    //       // MyCustomForm();
    //     }, //displaySecureResource(),
    //     style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.yellow, foregroundColor: Colors.black),
    //     child: const Text('Access_REST'),
    //   ),
    //   ElevatedButton(
    //     onPressed: () => AuthenticationHelper().signOut(),
    //     style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.yellow, foregroundColor: Colors.black),
    //     child: Text('Logout'),
    //   ),
    // )));
  }

  displaySecureResource() async {
    String response =
        await AuthenticationHelper().extractTokenAndAccessSecureResource();
    setState(() {
      textHolder = response;
    });
  }
}
