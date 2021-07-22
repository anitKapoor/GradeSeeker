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

  Future<String> getData(String category) async {
    var response =
        await http.post(Uri.parse("http://127.0.0.1:5000/prof"), headers: {"Accept": "application/json", "Access-Control-Allow-Origin": "*"}, body: {"Category": category, "ID": widget.id.toString()});
    var datafromJSON = json.decode(response.body) as List<dynamic>;
    // print(datafromJSON[0]);
    if (category == "classes") {
      courses = datafromJSON;
    }
    return "successful";
  }

  String classes_data() {
    return courses.length != 0 ? courses[0]["semester"] : "";
  }

  @override
  void initState() {
    getData("classes").then((classes) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text(widget.name),
                ),
              ),
              Align(
                child: Container(
                  child: Text(widget.rating),
                ),
              ),
              Align(
                child: Container(
                  child: Text(classes_data()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
