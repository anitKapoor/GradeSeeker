import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

void main() {
  runApp(Signup());
}

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscurePassword = true;
  String _userId = "";
  String _password = "";

  String hashVal(String toHash) {
    return sha256.convert(utf8.encode(toHash)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Card(
            child: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(children: [
        SizedBox(height: 50),
        RichText(text: TextSpan(text: 'Login', style: TextStyle(fontSize: 50))),
        SizedBox(height: 50),
        TextFormField(
          obscureText: false,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: 'Email ID'),
          onSaved: (String? value) {
            if (value != null) {
              _userId = value;
            } else {
              _userId = "";
            }
          },
          validator: (String? value) {
            RegExp emailExp =
                RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
            if (value != null &&
                (!emailExp.hasMatch(value) || value.length == 0)) {
              return ("Enter a valid email address!");
            } else {
              return null;
            }
          },
        ),
        SizedBox(height: 20),
        TextFormField(
            obscureText: _obscurePassword,
            onSaved: (String? value) {
              if (value != null) {
                _password = hashVal(value);
              } else {
                _userId = "";
              }
            },
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
          onPressed: () {},
          child: Text("Log In"),
        )
      ]),
    )));
  }
}

class Signup extends StatefulWidget {
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _userId = "", _firstName = "", _lastName = "", _password = "";
  bool _obscurePassword = true;

  String hashVal(String toHash) {
    return sha256.convert(utf8.encode(toHash)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Card(
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
                    TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Email ID'),
                      onSaved: (String? value) {
                        if (value != null) {
                          _userId = value;
                        } else {
                          _userId = "";
                        }
                      },
                      validator: (String? value) {
                        RegExp emailExp = RegExp(
                            r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)");
                        if (value != null &&
                            (!emailExp.hasMatch(value) || value.length == 0)) {
                          return ("Enter a valid email address!");
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: _obscurePassword,
                        onSaved: (String? value) {
                          if (value != null) {
                            _password = hashVal(value);
                          } else {
                            _userId = "";
                          }
                        },
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
                    TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First Name'),
                      onSaved: (String? value) {
                        if (value != null) {
                          _firstName = value;
                        } else {
                          _firstName = "";
                        }
                      },
                      validator: (String? value) {
                        RegExp nameExp = RegExp(r"(^[a-zA-Z])");
                        if (value != null &&
                            (!nameExp.hasMatch(value) || value.length == 0)) {
                          return ("Invalid characters found in name. ");
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Last Name'),
                      onSaved: (String? value) {
                        if (value != null) {
                          _lastName = value;
                        } else {
                          _lastName = "";
                        }
                      },
                      validator: (String? value) {
                        RegExp nameExp = RegExp(r"(^[a-zA-Z])");
                        if (value != null &&
                            (!nameExp.hasMatch(value) || value.length == 0)) {
                          return ("Invalid characters found in name. ");
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(onPressed: () {}, child: Text("Sign Up"))
                  ],
                ))));
  }
}
