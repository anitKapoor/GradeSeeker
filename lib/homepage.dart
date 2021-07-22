import 'package:flutter/material.dart';
import 'userutils/login_signup.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoggedIn = false;
  bool _isGuestUser = false;

  bool _displayLogin = false;
  bool _displaySignup = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: Column(
                children: [
              const Text(
                "Grade Seeker",
                textDirection: TextDirection.ltr,
                style: TextStyle(fontSize: 80, color: Colors.black),
              ),
              SizedBox(height: 20),
              Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _displayLogin = true;
                          });
                        },
                        child: const Text(
                          "Log In",
                          textDirection: TextDirection.ltr,
                        )),
                    SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _displaySignup = true;
                          });
                        },
                        child: const Text(
                          "Sign Up",
                          textDirection: TextDirection.ltr,
                        ))
                  ],
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment
                      .center //Center Row contents horizontally,
                  ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    _isLoggedIn = true;
                    _isGuestUser = true;
                  },
                  child: const Text(
                    "Continue as Guest",
                    textDirection: TextDirection.ltr,
                  ))
            ],
                mainAxisAlignment: MainAxisAlignment
                    .center //Center Column contents vertically,
                )),
        _displayLogin
            ? Align(
                alignment: Alignment.center,
                child: Container(child: Login(), width: 500, height: 500))
            : Container(),
        _displaySignup
            ? Align(
                alignment: Alignment.center,
                child: Container(child: Signup(), width: 500, height: 800))
            : Container()
      ],
    );
  }
}
