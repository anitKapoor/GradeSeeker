import 'dart:js';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profs.dart';

void main() {
  runApp(MaterialApp(
    home: BrowsePage(),
  ));
}

final key = new GlobalKey<_SelectionRow>();

class BrowsePage extends StatelessWidget {
  BrowsePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CategoryChoice());
  }
}

class CategoryChoice extends StatefulWidget {
  CategoryChoice({Key? key}) : super(key: key);
  @override
  _SelectionRow createState() => _SelectionRow();
}

class _SelectionRow extends State<CategoryChoice> {
  bool _profButton = true;
  int _offset = 0;
  List results = [];

  Future<String> getData() async {
    String table = _profButton ? "professors" : "courses";
    var response = await http
        .post(Uri.parse("http://127.0.0.1:5000/browse"), headers: {"Accept": "application/json", "Access-Control-Allow-Origin": "*"}, body: {"Category": table, "Offset": _offset.toString()});
    setState(() {
      var datafromJSON = json.decode(response.body) as List<dynamic>;
      results = datafromJSON;
    });
    // print('${results.length}');
    return "successful";
  }

  @override
  void initState() {
    getData().then((value) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataRow _getDataRow(data) {
      if (results == []) {
        return DataRow(cells: [DataCell.empty]);
      }
      String rat = "";
      if (_profButton && data["ratings"] != -1) {
        rat = data["ratings"].toString();
      } else {
        rat = "N/A";
      }

      return _profButton
          ? DataRow(
              cells: <DataCell>[
                DataCell(Text(data["firstName"])),
                DataCell(Text(data["lastName"])),
                DataCell(Text(rat)),
                DataCell(IconButton(
                  icon: const Icon(Icons.arrow_right),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfsPage(
                                  id: data['id'],
                                  name: data["firstName"] + " " + data["lastName"],
                                  rating: rat,
                                )));
                  },
                )),
              ],
            )
          : DataRow(
              cells: <DataCell>[
                DataCell(Text(data["courseCode"])),
                DataCell(Text(data["courseTitle"])),
                DataCell(Text(data["crn"].toString())),
              ],
            );
    }

    return Stack(
      children: <Widget>[
        Align(
          child: Container(
            child: TextButton(
              onPressed: () {
                setState(() {
                  results = [];
                  _offset = 0;
                  _profButton = !_profButton;
                  getData();
                });
              },
              child: Text(
                "By Professors",
                style: _profButton ? TextStyle(color: Colors.white) : TextStyle(color: Colors.amber[200]),
                textScaleFactor: 1.5,
              ),
              style: ButtonStyle(
                backgroundColor: _profButton ? MaterialStateProperty.all<Color>(Colors.amber) : MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.amber[200]!,
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            // margin: EdgeInsets.only(right: 5, left: 5),
          ),
          alignment: Alignment(-0.9, -0.95),
        ),
        Align(
          child: Container(
            child: TextButton(
              onPressed: () {
                setState(() {
                  results = [];
                  _offset = 0;
                  _profButton = !_profButton;
                  getData();
                });
              },
              child: Text(
                "By Course Name",
                style: !_profButton ? TextStyle(color: Colors.white) : TextStyle(color: Colors.amber[200]),
                textScaleFactor: 1.5,
              ),
              style: ButtonStyle(
                backgroundColor: !_profButton ? MaterialStateProperty.all<Color>(Colors.amber) : MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.amber[200]!,
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            margin: EdgeInsets.only(right: 5, left: 5),
          ),
          alignment: Alignment(-0.65, -0.95),
        ),
        Align(
          alignment: Alignment(0, 0),
          child: Container(
            width: 1510,
            height: 640,
            child: SingleChildScrollView(
              child: _profButton
                  ? DataTable(
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      columns: <DataColumn>[
                        DataColumn(
                            label: Container(
                          child: Text(
                            "First Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          width: 1510 * 0.3,
                        )),
                        DataColumn(
                            label: Container(
                          child: Text(
                            "Last Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          width: 1510 * 0.3,
                        )),
                        DataColumn(
                            label: Container(
                          child: Text(
                            "Ratings",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          width: 1510 * 0.3,
                        )),
                        DataColumn(
                            label: Container(
                          child: Text(
                            "More Information",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          width: 1510 * 0.1,
                        )),
                      ],
                      rows: List.generate(results.length, (index) => (_getDataRow(results[index]))),
                    )
                  : DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            "Course Code",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                            label: Text(
                          "Course Title",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          "CRN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                      rows: List.generate(results.length, (index) => (_getDataRow(results[index]))),
                    ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0.9, 0.9),
          child: GestureDetector(
            child: TextButton(
              child: Text(
                "Next",
                style: TextStyle(color: Colors.amber),
              ),
              onPressed: () {
                setState(() {
                  _offset++;
                  getData();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.amber[200]!,
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            onTap: () {},
          ),
        ),
        Align(
          alignment: Alignment(0, 0.9),
          child: Container(
            child: TextButton(
              child: Text(
                "First",
                style: TextStyle(color: Colors.amber),
              ),
              onPressed: () {
                setState(() {
                  _offset = 0;
                  getData();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.amber[200]!,
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(-0.9, 0.9),
          child: Container(
            child: TextButton(
              child: Text(
                "Back",
                style: TextStyle(color: Colors.amber),
              ),
              onPressed: () {
                setState(() {
                  if (_offset != 0) {
                    _offset--;
                    getData();
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.amber[200]!,
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
