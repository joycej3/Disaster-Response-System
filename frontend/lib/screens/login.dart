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
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
            child: SizedBox(
              child: Text("EMS Worker / Coordinator Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red)),
            ),
          ),
          // email
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
            child: SizedBox(
              width: 340,
              height: 40,
              child: TextFormField(
                // initialValue: 'Input text',
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      const Radius.circular(100.0),
                    ),
                  ),
                ),
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
            ),
          ),
          //gap between email and password
          SizedBox(
            width: 10,
            height: 25,
          ),

          // password
          Padding(
            padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
            child: SizedBox(
              height: 40,
              width: 340,
              child: TextFormField(
                // initialValue: 'Input text',
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      const Radius.circular(100.0),
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),
                ),
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
            ),
          ),
          //gap between password and login button
          SizedBox(width: 10, height: 20),

          //login button
          Padding(
            padding: EdgeInsets.fromLTRB(60, 0, 0, 0),
            child: SizedBox(
              height: 50,
              width: 146,
              child: ElevatedButton(
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)))),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
