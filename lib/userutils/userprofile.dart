import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(UserProfile());
}

class UserProfile extends StatefulWidget {
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _obscurePassword = true;
  String _password = "", _firstName = "", _lastName = "";

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
                    text: "User Profile", style: TextStyle(fontSize: 50))),
            SizedBox(height: 50),
            TextFormField(
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Update First Name'),
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
                  border: OutlineInputBorder(), labelText: 'Update Last Name'),
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
            SizedBox(height: 20),
            TextFormField(
                obscureText: _obscurePassword,
                onSaved: (String? value) {
                  if (value != null) {
                    _password = hashVal(value);
                  } else {
                    _password = "";
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Update Password',
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
            SizedBox(height: 50),
            ElevatedButton(onPressed: () {}, child: Text("Save Changes")),
          ],
        ),
      ),
    ));
  }
}
