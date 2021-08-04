import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeseeker/arguments.dart';
import 'package:http/http.dart' as http;
import 'classes.dart';
import 'profs.dart';

class Search extends StatefulWidget {
  final UserArgs args;
  const Search(this.args);
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool crnSearch = true, courseCode = false, profSearch = false;
  bool displayCRNTable = false, displayCourseTable = false, displayProfTable = false, isDataReady = false;

  dynamic jsonobjs;

  final searchController = TextEditingController();

  Future<String> searchData() async {
    String searchPath = "";
    if (crnSearch) {
      searchPath = "crn/${searchController.text}";
    } else if (courseCode) {
      searchPath = "class/${searchController.text}";
    } else {
      List<String> profName = (searchController.text).trim().split(' ');
      if (profName.length == 2) {
        searchPath = profName[0] + ',' + profName[1];
      } else {
        searchPath = profName[0] + ' ' + profName[1] + ',' + profName[2];
      }
      searchPath = "professor/" + searchPath;
    }

    String url = "http://127.0.0.1:5000/search/$searchPath";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    jsonobjs = jsonDecode(jsonDecode(response.body)["data"]);
    setState(() {
      if (crnSearch) {
        displayCRNTable = true;
        displayCourseTable = false;
        displayProfTable = false;
      } else if (courseCode) {
        displayCRNTable = false;
        displayCourseTable = true;
        displayProfTable = false;
      } else {
        displayCRNTable = false;
        displayCourseTable = false;
        displayProfTable = true;
      }
      isDataReady = true;
    });
    return "";
  }

  List<DataRow> getRows() {
    List<DataRow> toReturn = [];
    if (displayCRNTable) {
      for (dynamic data in jsonobjs) {
        toReturn.add(DataRow(cells: <DataCell>[
          DataCell(Text(data["crn"].toString())),
          DataCell(Text(data["courseCode"])),
          DataCell(
            Text(data["courseTitle"]),
          ),
          DataCell(
            IconButton(
              icon: const Icon(
                Icons.arrow_right,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassesPage(
                      code: data["courseCode"],
                      title: data["courseTitle"],
                      crn: data["crn"],
                      av: data["av"], // PANAV ADD AVERAGE GRADE TO QUERY
                    ),
                  ),
                );
              },
            ),
          ),
        ]));
      }
    } else if (displayCourseTable) {
      for (dynamic data in jsonobjs) {
        toReturn.add(DataRow(cells: <DataCell>[
          DataCell(Text(data["courseCode"])),
          DataCell(
            Text(data["courseTitle"]),
          )
        ]));
      }
    } else {
      print(jsonobjs);
      for (dynamic data in jsonobjs) {
        toReturn.add(
          DataRow(
            cells: <DataCell>[
              DataCell(Text(data["CourseCode"])),
              DataCell(Text(data["courseTitle"])),
              DataCell(Text(data["semester"])),
              DataCell(Text(data["firstName"].toString() + " " + data["lastName"].toString())),
              DataCell(
                IconButton(
                  icon: const Icon(
                    Icons.arrow_right,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfsPage(
                          id: data['id'], // PANAV ADD PROFS ID
                          name: data["firstName"] + " " + data["lastName"],
                          rating: data['rating'], // PANAV ADD RATING TO THE QUERY PLEASE
                          userVal: widget.args,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 20),
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(crnSearch ? Colors.amber : Colors.white),
                      textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black))),
                  onPressed: () {
                    setState(() {
                      crnSearch = true;
                      courseCode = false;
                      profSearch = false;
                    });
                  },
                  child: Text("Search by CRN")),
              SizedBox(width: 20),
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(courseCode ? Colors.amber : Colors.white),
                      textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black))),
                  onPressed: () {
                    setState(() {
                      crnSearch = false;
                      courseCode = true;
                      profSearch = false;
                    });
                  },
                  child: Text("Search by Course Code")),
              SizedBox(width: 20),
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(profSearch ? Colors.amber : Colors.white),
                      textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black))),
                  onPressed: () {
                    setState(() {
                      crnSearch = false;
                      courseCode = false;
                      profSearch = true;
                    });
                  },
                  child: Text("Search by Professor"))
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 800,
                child: TextField(
                  controller: searchController,
                  obscureText: false,
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Enter Search Query'),
                ),
              ),
              SizedBox(width: 50),
              ElevatedButton(
                  onPressed: () async {
                    await searchData();
                  },
                  child: Text("Search"))
            ],
          ),
          SizedBox(height: 50),
          isDataReady
              ? (displayCRNTable
                  ? DataTable(columns: const <DataColumn>[
                      DataColumn(label: Text("CRN")),
                      DataColumn(label: Text("Course Code")),
                      DataColumn(label: Text("Course Title")),
                      DataColumn(
                          label: Text(
                        "More Information",
                      )),
                    ], rows: getRows())
                  : (displayCourseTable
                      ? DataTable(columns: const <DataColumn>[DataColumn(label: Text("Course Code")), DataColumn(label: Text("Course Title"))], rows: getRows())
                      : DataTable(columns: const <DataColumn>[
                          DataColumn(
                            label: Text("Course Code"),
                          ),
                          DataColumn(
                            label: Text("Course Title"),
                          ),
                          DataColumn(
                            label: Text("Course Semester"),
                          ),
                          DataColumn(
                            label: Text("Professor Name"),
                          ),
                          DataColumn(
                            label: Text(
                              "More Information",
                            ),
                          ),
                        ], rows: getRows())))
              : Container()
        ],
      ),
    );
  }
}
