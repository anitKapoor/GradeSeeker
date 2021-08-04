import 'package:flutter/material.dart';
import 'package:gradeseeker/arguments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profs.dart';
import 'classes.dart';

final key = new GlobalKey<_SelectionRow>();

class BrowsePage extends StatelessWidget {
  final UserArgs args;
  BrowsePage(this.args);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return Container(
          child: CategoryChoice(args), constraints: viewportConstraints);
    });
  }
}

class CategoryChoice extends StatefulWidget {
  final UserArgs args;
  CategoryChoice(this.args);
  @override
  _SelectionRow createState() => _SelectionRow(args);
}

class _SelectionRow extends State<CategoryChoice> {
  bool _profButton = true;
  int _offset = 0;
  List results = [];
  final UserArgs userVal;

  _SelectionRow(this.userVal);

  Future<String> getData() async {
    String table = _profButton ? "professors" : "courses";
    var response = await http.post(
      Uri.parse("http://127.0.0.1:5000/browse"),
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      },
      body: {
        "Category": table,
        "Offset": _offset.toString(),
      },
    );
    setState(() {
      var datafromJSON = json.decode(response.body) as List<dynamic>;
      results = datafromJSON;
      // print(results);
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
                            userVal: userVal),
                      ),
                    );
                  },
                )),
              ],
            )
          : DataRow(
              cells: <DataCell>[
                DataCell(Text(data["courseCode"])),
                DataCell(Text(data["courseTitle"])),
                DataCell(Text(data["crn"].toString())),
                DataCell(Text(data["av"].toStringAsFixed(2))),
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
                                    av: data["av"],
                                  )));
                    },
                  ),
                ),
              ],
            );
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  style: _profButton
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.amber[200]),
                  textScaleFactor: 1.5,
                ),
                style: ButtonStyle(
                  backgroundColor: _profButton
                      ? MaterialStateProperty.all<Color>(Colors.amber)
                      : MaterialStateProperty.all<Color>(Colors.white),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.amber[200]!,
                            style: BorderStyle.solid,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
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
                  style: !_profButton
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.amber[200]),
                  textScaleFactor: 1.5,
                ),
                style: ButtonStyle(
                  backgroundColor: !_profButton
                      ? MaterialStateProperty.all<Color>(Colors.amber)
                      : MaterialStateProperty.all<Color>(Colors.white),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
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
        ),
        Container(
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
                    rows: List.generate(results.length,
                        (index) => (_getDataRow(results[index]))),
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
                      DataColumn(
                          label: Text(
                        "Average Grade",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        "More Information",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                    rows: List.generate(results.length,
                        (index) => (_getDataRow(results[index]))),
                  ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
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
            Container(
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.amber[200]!,
                            style: BorderStyle.solid,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
            ),
            Container(
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
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.amber[200]!,
                            style: BorderStyle.solid,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
