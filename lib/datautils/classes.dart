import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClassesPage extends StatefulWidget {
  final String code;
  final String title;
  final int crn;
  final double av;
  const ClassesPage({Key? key, required this.code, required this.title, required this.crn, required this.av}) : super(key: key);

  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  List professors = [];
  double stdDev = 0.0;
  bool render_courses = false;

  @override
  void initState() {
    super.initState();
    pop();
  }

  void pop() async {
    await newGetData();
  }

  Future newGetData() async {
    var response = await http.post(
      Uri.parse("http://127.0.0.1:5000/classes"),
      headers: {"Accept": "application/json", "Access-Control-Allow-Origin": "*"},
      body: {
        "crn": widget.crn.toString(),
      },
    );
    var datafromJSON = json.decode(response.body) as List<dynamic>;
    professors = datafromJSON;
    setState(() {
      render_courses = true;
    });
    return "successful";
  }

  @override
  Widget build(BuildContext context) {
    DataRow _getDataRow(data) {
      return DataRow(
        cells: <DataCell>[
          DataCell(Text(data["firstName"] + " " + data["lastName"])),
          DataCell(Text(data["semester"])),
        ],
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_left),
          ),
          Column(
            children: <Widget>[
              Align(
                child: Container(
                  child: Text("Course Title : " + widget.title),
                ),
              ),
              Align(
                child: Container(
                  child: Text("Course Code : " + widget.code),
                ),
              ),
              Align(
                child: Container(
                  child: Text("CRN: " + widget.crn.toString()),
                ),
              ),
              Align(
                child: Container(
                  child: Text("Average Score : " + widget.av.toString()),
                ),
              ),
              Align(
                child: Container(
                  child: Text("Standard Deviation : " + stdDev.toStringAsFixed(2)),
                ),
              ),
              Align(
                child: Container(
                  child: render_courses
                      ? SingleChildScrollView(
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Container(
                                child: Text(
                                  "Professor Name",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                              DataColumn(
                                  label: Container(
                                child: Text(
                                  "Semester taught",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              )),
                            ],
                            rows: List.generate(professors.length, (index) => (_getDataRow(professors[index]))),
                          ),
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
