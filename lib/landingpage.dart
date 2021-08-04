import 'package:flutter/material.dart';
import 'userutils/login_signup.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          ),
      home: LandingPage()));
}

class LandingPage extends StatefulWidget {
  static const String route = '/';
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _displayLogin = false;
  bool _displaySignup = false;
  void _hideLogin() {
    setState(() {
      _displayLogin = false;
    });
  }

  void _hideSignup() {
    setState(() {
      _displaySignup = false;
    });
  }

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
            ],
                mainAxisAlignment: MainAxisAlignment
                    .center //Center Column contents vertically,
                )),
        _displayLogin
            ? Align(
                alignment: Alignment.center,
                child: Container(
                    child: Login(_hideLogin), width: 500, height: 500))
            : Container(),
        _displaySignup
            ? Align(
                alignment: Alignment.center,
                child: Container(
                    child: Signup(_hideSignup), width: 500, height: 800))
            : Container()
      ],
    );
  }
}
