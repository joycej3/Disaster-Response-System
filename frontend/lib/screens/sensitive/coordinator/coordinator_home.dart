import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_map.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/big_red_button.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator_options.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/stats.dart';
import 'package:flutter_frontend/screens/sensitive/coordinator/coordinator.dart';
import 'package:flutter_frontend/services/authentication.dart';

class CoordinatorHome extends StatefulWidget {
  CoordinatorHome({Key? key}) : super(key: key);

  @override
  CoordinatorHomeState createState() => CoordinatorHomeState();
}

class CoordinatorHomeState extends State<CoordinatorHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.white,
          title: Text('Coordinator Page', style: TextStyle(fontSize: 52)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.control_point,
                        color: Colors.yellow,
                        size: 70,
                      ),
                      Text('DRS',
                          style: TextStyle(color: Colors.yellow, fontSize: 56))
                    ],
                  )),
              SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Coordinator()),
                      ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueGrey),
                  child:
                      Text('Coordinator Page', style: TextStyle(fontSize: 28))),
              SizedBox(height: 40, width: 0),
              ElevatedButton(
                onPressed: () => AuthenticationHelper().signOut(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueGrey),
                child: Text('Logout', style: TextStyle(fontSize: 28)),
              ),
            ],
          ),
        ),
        backgroundColor: Color.lerp(Colors.blueAccent, Colors.blue, 5),
      ),
      // backgroundColor: Color.fromRGBO(26, 180, 217, 1)),)
    );
  }
}
