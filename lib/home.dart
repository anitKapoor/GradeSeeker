import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gradeseeker/arguments.dart';
import 'package:gradeseeker/datautils/browse.dart';
import 'package:gradeseeker/datautils/search.dart';
import 'package:gradeseeker/userutils/userprofile.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  static const String route = '/home';
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isBrowse = true;
  bool isSearch = false;
  bool isEditProfile = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArgs;

    return new WillPopScope(
        onWillPop: () async => false,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Welcome back ${args.userID}!",
              style: TextStyle(color: Colors.black, decoration: TextDecoration.none),
            ),
            SizedBox(height: 20),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        backgroundColor: MaterialStateProperty.all(isBrowse ? Colors.amber : Colors.white),
                        textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black))),
                    onPressed: () {
                      setState(() {
                        isEditProfile = false;
                        isSearch = false;
                        isBrowse = true;
                      });
                    },
                    child: Text("Browse")),
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        backgroundColor: MaterialStateProperty.all(isSearch ? Colors.amber : Colors.white),
                        textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black))),
                    onPressed: () {
                      setState(() {
                        isEditProfile = false;
                        isSearch = true;
                        isBrowse = false;
                      });
                    },
                    child: Text("Search")),
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        backgroundColor: MaterialStateProperty.all(isEditProfile ? Colors.amber : Colors.white),
                        textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black))),
                    onPressed: () {
                      setState(() {
                        isEditProfile = true;
                        isSearch = false;
                        isBrowse = false;
                      });
                    },
                    child: Text("Edit User Profile")),
                ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.black),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Sign Out"))
              ],
            ),
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                isSearch
                    ? Search(
                        args,
                      )
                    : (isBrowse ? BrowsePage(args) : Align(alignment: Alignment.center, child: Container(child: UserProfile(args), width: 500, height: 800)))
              ],
            )
          ],
        ));
  }
}
