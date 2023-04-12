import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/login.dart';
import 'package:flutter_frontend/screens/custom_form.dart';
import 'package:flutter_frontend/screens/map.dart';
import 'package:http/http.dart';
import '../../../services/api.dart';
import '../../../services/authentication.dart';

class RedButton extends StatefulWidget {
  RedButton({Key? key}) : super(key: key);

  @override
  DrawRedButton createState() => DrawRedButton();
}

class DrawRedButton extends State<RedButton> {
  @override
  Widget build(BuildContext context) {
    AuthenticationHelper authenticationHelper = AuthenticationHelper();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                  ),
                  height: 40,
                  child: Text(
                    "    End Disaster Response by clicking X button below    ",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                RawMaterialButton(
                  onPressed: () => pushButton(authenticationHelper),
                  elevation: 2.0,
                  fillColor: Colors.red,
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.cancel_sharp,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height / 2.5,
                  ),
                ),
                SizedBox(height: 75),
                ElevatedButton(
                  onPressed: () => AuthenticationHelper().signOut(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white),
                  child: Text('Press this button to Logout',
                      style: TextStyle(fontSize: 28)),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> pushButton(AuthenticationHelper authenticationHelper) async {
    Response response = await authenticationHelper.secureApi("red_button");
    int answer = response.statusCode;
    print(answer);
  }
}
