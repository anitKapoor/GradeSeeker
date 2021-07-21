// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => BrowsePage(),
    },
  ));
}

class BrowsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CategoryChoice());
  }
}

class CategoryChoice extends StatefulWidget {
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

  double edge = 100;
  DataRow _getDataRow(data) {
    if (results == []) {
      return DataRow(cells: [DataCell.empty]);
    }
    return _profButton
        ? DataRow(
            cells: <DataCell>[
              DataCell(Text(data["firstName"])),
              DataCell(Text(data["lastName"])),
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

  @override
  void initState() {
    getData().then((value) {
      print("async done");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          child: Row(
            children: [
              Container(
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
                margin: EdgeInsets.only(right: 5, left: 5),
              ),
              Container(
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
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
          ),
          heightFactor: 76.8 / 39,
          widthFactor: 365 / 1536,
        ),
        Align(
          alignment: Alignment(0, 0),
          child: Container(
            child: SingleChildScrollView(
              child: _profButton
                  ? DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                            label: Text(
                          "First Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          "Last Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
            height: 640,
            width: 1510,
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
