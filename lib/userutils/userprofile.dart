import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../arguments.dart';

class UserProfile extends StatefulWidget {
  final UserArgs currUser;
  UserProfile(this.currUser);

  _UserProfileState createState() => _UserProfileState(currUser);
}

class _UserProfileState extends State<UserProfile> {
  bool _obscurePassword = true;

  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  FToast? fToast;
  UserArgs? currUser;

  _UserProfileState(this.currUser);
  @override
  void initState() {
    populateInfo();

    super.initState();
    fToast = FToast();
    fToast?.init(context);
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

  void populateInfo() async {
    await _getUserInfo();
  }

  String hashVal(String toHash) {
    return sha256.convert(utf8.encode(toHash)).toString();
  }

  Future<bool> _changeUserInfo() async {
    http.Response returned = await http.post(
        Uri.parse("http://127.0.0.1:5000/userprofile=${currUser!.userID}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "user_upass": hashVal(passwordController.text),
          "user_ufname": firstNameController.text,
          "user_ulname": lastNameController.text
        }));
    dynamic jsonobjs = jsonDecode(returned.body);
    if (jsonobjs["update"] == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _getUserInfo() async {
    http.Response returned = await http.get(
        Uri.parse("http://127.0.0.1:5000/userprofile=${currUser!.userID}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    dynamic jsonobj = jsonDecode(returned.body);
    if (jsonobj["firstName"] != null && jsonobj["lastName"] != null) {
      firstNameController.text = jsonobj["firstName"];
      lastNameController.text = jsonobj["lastName"];
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _deleteUser() async {
    http.Response returned = await http.post(
        Uri.parse("http://127.0.0.1:5000/delete=${currUser!.userID}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    dynamic jsonobjs = jsonDecode(returned.body);
    if (jsonobjs["deleted"] == 1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: [
            SizedBox(height: 20),
            RichText(
                text: TextSpan(
                    text: "User Profile", style: TextStyle(fontSize: 50))),
            SizedBox(height: 50),
            TextField(
                obscureText: false,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Update First Name'),
                controller: firstNameController),
            SizedBox(height: 20),
            TextField(
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Update Last Name'),
              controller: lastNameController,
            ),
            SizedBox(height: 20),
            TextField(
                obscureText: _obscurePassword,
                controller: passwordController,
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
            ElevatedButton(
                onPressed: () async {
                  bool status = await _changeUserInfo();
                  setState(() {
                    if (status) {
                      _showToast("User Profile Updated!");
                    }
                  });
                },
                child: Text("Save Changes")),
            SizedBox(height: 50),
            ElevatedButton(
                onPressed: () async {
                  bool status = await _deleteUser();
                  setState(() {
                    if (status) {
                      _showToast("User Deleted!");
                    }
                  });
                },
                child: Text("Delete User")),
          ],
        ),
      ),
    );
  }
}
