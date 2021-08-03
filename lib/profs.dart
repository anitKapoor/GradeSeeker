import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfsPage extends StatefulWidget {
  final int id;
  final String name;
  final String rating;
  const ProfsPage({Key? key, required this.id, required this.name, required this.rating}) : super(key: key);

  @override
  _ProfsPageState createState() => _ProfsPageState();
}

class _ProfsPageState extends State<ProfsPage> {
  List courses = [];
  bool render_courses = false;
  double averageGpa = 0;
  bool render_average = false;

  @override
  void initState() {
    super.initState();
    pop();
  }

  void pop() async {
    await newGetData("classes");
    await newGetData("average");
  }

  Future newGetData(String category) async {
    var response = await http.post(
      Uri.parse("http://127.0.0.1:5000/prof"),
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

    return Scaffold(
      appBar: AppBar(
         title: const Text('Professors'),
         backgroundColor: Colors.yellow,
        ),
      body: Stack(
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
                  child: Text("Rating : " + widget.rating),
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
                          ),
                        )
                      : Container(),
                ),
              ),
              Align(
                child: Container(
                  child: render_average ? Text("Average GPA in Courses: " + averageGpa.toString()) : Container(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
