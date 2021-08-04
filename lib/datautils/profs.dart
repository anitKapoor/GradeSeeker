import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gradeseeker/arguments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../database.dart';

class ProfsPage extends StatefulWidget {
  final int id;
  final String name;
  final String rating;
  final UserArgs userVal;
  const ProfsPage({
    Key? key,
    required this.id,
    required this.name,
    required this.rating,
    required this.userVal,
  }) : super(key: key);

  @override
  _ProfsPageState createState() => _ProfsPageState(userVal);
}

class _ProfsPageState extends State<ProfsPage> {
  final UserArgs userVal;
  List courses = [];
  bool render_courses = false;
  double averageGpa = 0;
  bool render_average = false;
  List comments = [];
  bool render_comments = false;
  String? dropdownvalue = '1';
  bool update_ratings = false;
  String rat = "";
  var items = ['1', '2', '3', '4', '5'];
  final TextEditingController commentController = TextEditingController();
  final TextEditingController crnController = TextEditingController();

  _ProfsPageState(this.userVal);
  @override
  void initState() {
    super.initState();
    pop();
  }

  void pop() async {
    await newGetData("classes");
    await newGetData("average");
    await postComments("get");
  }

  Future newGetData(String category) async {
    var response = await http.post(
      Uri.parse(flaskPath + "/prof"),
      headers: {"Accept": "application/json", "Access-Control-Allow-Origin": "*"},
      body: {
        "Category": category,
        "ID": widget.id.toString(),
      },
    );
    if (category == "classes") {
      var datafromJSON = json.decode(response.body) as List<dynamic>;
      courses = datafromJSON;
      setState(() {
        render_courses = true;
      });
    }
    if (category == "average") {
      var datafromJSON = json.decode(response.body) as Map<String, dynamic>;
      averageGpa = datafromJSON["av"];
      setState(() {
        render_average = true;
      });
    }
    if (category == "update") {
      var datafromJSON = json.decode(response.body);
      rat = datafromJSON["ratings"].toString();
      setState(() {
        update_ratings = true;
      });
    }
    return "successful";
  }

  Future postComments(String choice) async {
    var response;
    if (choice == "get") {
      response = await http.post(
        Uri.parse(flaskPath + "/getComm"),
        headers: {"Accept": "application/json", "Access-Control-Allow-Origin": "*"},
        body: {
          "ID": widget.id.toString(),
        },
      );
      var datafromJSON = json.decode(response.body) as List<dynamic>;
      comments = datafromJSON;
      setState(() {
        render_comments = true;
      });
    }
    if (choice == "post") {
      response = await http.post(Uri.parse(flaskPath + "/postComm"),
          headers: <String, String>{
            "Accept": "application/json",
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, String>{
              "ID": widget.id.toString(),
              "comm": commentController.text,
              "rat": dropdownvalue.toString(),
              "crn": crnController.text,
              "userId": userVal.userID,
            },
          ));
      // var datafromJSON = json.decode(response.body) as List<dynamic>;
      // comments = datafromJSON;
      // setState(() {
      //   render_comments = true;
      // });
    }
    return "successful";
  }

  @override
  Widget build(BuildContext context) {
    DataRow _getDataRow(data) {
      return DataRow(
        cells: <DataCell>[
          DataCell(Text(data["crn"].toString())),
          DataCell(Text(data["semester"])),
        ],
      );
    }

    DataRow parseComments(data) {
      return DataRow(
        cells: [
          DataCell(
            Text(
              data["userId"].toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataCell(Text(
            data["comments"],
            style: TextStyle(fontStyle: FontStyle.italic),
          )),
          DataCell(Text(
            "Voted on " + data["courseCode"].toString(),
            style: TextStyle(fontSize: 12),
          )),
        ],
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_left),
              color: Colors.black,
            ),
            Column(
              children: <Widget>[
                Align(
                  child: Container(
                    child: Text("Name : " + widget.name),
                  ),
                ),
                Align(
                  child: Container(
                    child: !update_ratings ? Text("Rating : " + widget.rating) : Text("Rating : " + rat.toString()),
                  ),
                ),
                Align(
                  child: Container(
                    child: render_average ? Text("Average GPA in Courses: " + averageGpa.toString()) : Container(),
                  ),
                ),
                Align(
                  child: Container(
                    child: render_courses
                        ? DataTable(
                            columns: [
                              DataColumn(
                                  label: Container(
                                child: Text(
                                  "CRN",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                              DataColumn(
                                  label: Container(
                                child: Text(
                                  "Semester",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                            ],
                            rows: List.generate(courses.length, (index) => (_getDataRow(courses[index]))),
                          )
                        : Container(),
                  ),
                ),
                Container(
                  alignment: Alignment(-0.51, -1),
                  child: Text(
                    "User comments",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 800.0,
                      child: TextField(
                        controller: commentController,
                        obscureText: false,
                        decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Enter New Comment'),
                      ),
                    ),
                    DropdownButton(
                      value: dropdownvalue,
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(value: items, child: Text(items));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue;
                        });
                      },
                    ),
                    Container(
                      width: 100.0,
                      child: TextField(
                        controller: crnController,
                        obscureText: false,
                        decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Enter CRN'),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () async {
                          await postComments("post");
                          await postComments("get");
                          await newGetData("update");
                        },
                        child: Text("Post!"))
                  ],
                ),
                DataTable(
                  headingRowHeight: 0,
                  dividerThickness: 0.00001,
                  columns: [DataColumn(label: Container()), DataColumn(label: Container()), DataColumn(label: Container())],
                  rows: render_comments ? List.generate(comments.length, (index) => parseComments(comments[index])) : [],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
