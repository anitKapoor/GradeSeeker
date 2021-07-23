import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool crnSearch = true, courseCode = false;
  bool displayCRNTable = false, isDataReady = false;
  dynamic jsonobjs;

  final searchController = TextEditingController();

  Future<String> searchData() async {
    String url =
        "http://127.0.0.1:5000/search/${crnSearch ? "crn/${searchController.text}" : "class/${searchController.text}"}";
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
      } else {
        displayCRNTable = false;
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
          DataCell(Text(data["courseTitle"]))
        ]));
      }
    } else {
      for (dynamic data in jsonobjs) {
        toReturn.add(DataRow(cells: <DataCell>[
          DataCell(Text(data["courseCode"])),
          DataCell(Text(data["courseTitle"]))
        ]));
      }
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          SizedBox(height: 30),
          Row(
            children: [
              SizedBox(width: 20),
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(
                          crnSearch ? Colors.yellow : Colors.white),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.black))),
                  onPressed: () {
                    setState(() {
                      crnSearch = true;
                      courseCode = false;
                    });
                  },
                  child: Text("Search by CRN")),
              SizedBox(width: 20),
              ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                      backgroundColor: MaterialStateProperty.all(
                          courseCode ? Colors.yellow : Colors.white),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(color: Colors.black))),
                  onPressed: () {
                    setState(() {
                      crnSearch = false;
                      courseCode = true;
                    });
                  },
                  child: Text("Search by Course Code"))
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
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Search Query'),
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
              ? (!displayCRNTable
                  ? DataTable(columns: const <DataColumn>[
                      DataColumn(label: Text("Course Code")),
                      DataColumn(label: Text("Course Title"))
                    ], rows: getRows())
                  : DataTable(columns: const <DataColumn>[
                      DataColumn(label: Text("CRN")),
                      DataColumn(label: Text("Course Code")),
                      DataColumn(label: Text("Course Title"))
                    ], rows: getRows()))
              : Container()
        ],
      ),
    ));
  }
}
