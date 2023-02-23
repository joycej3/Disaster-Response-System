import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/authentication.dart';
//replace this with where to go
import 'package:flutter_frontend/screens/sensitive/worker.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Text("EMS Worker / Coordinator Login",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 24)),

            // // email
            SizedBox(height: 15),
            // Padding(
            //   padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
            //   child: SizedBox(
            //     width: 340,
            //     height: 40,
            // child:
            TextFormField(
              // initialValue: 'Input text',
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Colors.white,
                ),
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red, width: 2)),
                filled: true,
                fillColor: Colors.redAccent,
              ),

              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.all(
              //       const Radius.circular(100.0),
              //     ),
              //   ),
              // ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (val) {
                email = val;
              },
            ),
            //   ),
            // ),
            //gap between email and password
            SizedBox(
              height: 15,
            ),
            TextFormField(
              // initialValue: 'Input text',
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                labelStyle: const TextStyle(color: Colors.white, fontSize: 18),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.red, width: 1)),
                filled: true,
                fillColor: Colors.redAccent,
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  // suffixIcon: IconButton(
                  //   icon: _obscureText ? Icons.visibility_off : Icons.visibility,
                  //   color: Colors.white,
                  //   )
                  // onTap: () {
                  //   setState(() {
                  //     _obscureText = !_obscureText;
                  //   });
                  // },
                  // child: Icon(
                  //   _obscureText ? Icons.visibility_off : Icons.visibility,
                  //   color: Colors.white,
                  // ),
                ),
              ),
              //Decoration(color: Colors.white),
              obscureText: _obscureText,
              onSaved: (val) {
                password = val;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            //gap between password and login button
            SizedBox(width: 10, height: 20),
            ElevatedButton(
              onPressed: () {
                // Respond to button press

                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  AuthenticationHelper()
                      .signIn(email: email!, password: password!)
                      .then((result) {
                    if (result == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkerPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          result,
                          style: TextStyle(fontSize: 16),
                        ),
                      ));
                    }
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 3, color: Colors.red),
                  foregroundColor: Colors.white,
                  shadowColor: Colors.red,
                  backgroundColor: Colors.redAccent,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  fixedSize: Size(100, 50)),
              child: Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
