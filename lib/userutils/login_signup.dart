import 'dart:convert';
import 'package:gradeseeker/arguments.dart';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradeseeker/home.dart';
import 'package:http/http.dart' as http;

import '../database.dart';

class Login extends StatefulWidget {
  final VoidCallback _hideLogin;

  Login(this._hideLogin);
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FToast? fToast;
  bool _obscurePassword = true;
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  String setUserName = "";

  final showToast = false;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
  }

  String hashVal(String toHash) {
    return sha256.convert(utf8.encode(toHash)).toString();
  }

  Future<int> _postLogin() async {
    print(hashVal(passwordController.text));

    http.Response returned = await http.post(Uri.parse(flaskPath + "/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "user_id": userController.text,
          "user_pass": hashVal(passwordController.text)
        }));
    print(jsonDecode(returned.body));
    if (jsonDecode(returned.body)["login_attempt"] == 1) {
      return 1;
    } else {
      return 0;
    }
  }

  _showToast(String toastMessage) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(toastMessage),
        ],
      ),
    );

    fToast?.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        SizedBox(height: 50),
        RichText(text: TextSpan(text: 'Login', style: TextStyle(fontSize: 50))),
        SizedBox(height: 50),
        TextField(
          obscureText: false,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Email ID'),
          controller: userController,
        ),
        SizedBox(height: 20),
        TextField(
            obscureText: _obscurePassword,
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            )),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            setUserName = userController.text;
            int toastCode = await _postLogin();
            print(toastCode);
            setState(() {
              if (toastCode == 1) {
                print("here");
                widget._hideLogin();

                _showToast("Login Successful!");
                Navigator.pushNamed(context, Home.route,
                    arguments: UserArgs(setUserName, false, true));
              } else {
                _showToast("Invalid Login Details. Please try again!");
              }
            });
          },
          child: Text("Log In"),
        ),
      ]),
    );
  }
}

class Signup extends StatefulWidget {
  final VoidCallback _hideSignup;

  Signup(this._hideSignup);
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailIDController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  FToast? fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
  }

  String hashVal(String toHash) {
    return sha256.convert(utf8.encode(toHash)).toString();
  }

  _showToast(String toastMessage) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text(toastMessage),
        ],
      ),
    );

    fToast?.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }

  Future<String> _postSignIn() async {
    http.Response returned = await http.post(Uri.parse(flaskPath + "/signup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "user_id": emailIDController.text,
          "user_pass": hashVal(passwordController.text),
          "user_fname": fnameController.text,
          "user_lname": lnameController.text
        }));
    if (jsonDecode(returned.body)["signup_attempt"] == 1) {
      widget._hideSignup();
      return "Signup Successful!";
    } else if (jsonDecode(returned.body)["error"] != null) {
      return "error: ${jsonDecode(returned.body)["error"]}";
    } else {
      return "User ID already exists!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(),
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              children: [
                SizedBox(height: 20),
                RichText(
                    text: TextSpan(
                        text: "Create account for GradeSeeker",
                        style: TextStyle(fontSize: 50))),
                SizedBox(height: 50),
                TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email ID'),
                  controller: emailIDController,
                ),
                SizedBox(height: 20),
                TextField(
                    obscureText: _obscurePassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    )),
                SizedBox(height: 20),
                TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'First Name'),
                  controller: fnameController,
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Last Name'),
                  controller: lnameController,
                ),
                SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () async {
                      String signupString = await _postSignIn();
                      setState(() {
                        _showToast(signupString);
                      });
                    },
                    child: Text("Sign Up"))
              ],
            )));
  }
}
