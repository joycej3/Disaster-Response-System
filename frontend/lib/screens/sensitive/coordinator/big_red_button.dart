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
      home: Scaffold(
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(onPressed: () => pushButton(authenticationHelper),
                child: Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ))),

      ),

    );
  }
  Future<void> pushButton(AuthenticationHelper authenticationHelper) async {
    Response response = await authenticationHelper.secureApi("red_button");
    int answer =  response.statusCode;
    print(answer);
  }
}
