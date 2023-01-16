import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add.dart';
import 'edit.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List _get = [];

  final _lightColors = [
    Color.fromARGB(255, 106, 137, 223),
    Color.fromARGB(255, 106, 137, 223),
    Color.fromARGB(255, 106, 137, 223),
    Color.fromARGB(255, 106, 137, 223),
    Color.fromARGB(255, 106, 137, 223),
    Color.fromARGB(255, 106, 137, 223)
  ];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http
          .get(Uri.parse("http://localhost/latihan/note_app/list.php"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _get = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catatan Tugas'),
      ),
      body: _get.length != 0
          ? MasonryGridView.count(
              crossAxisCount: 2,
              itemCount: _get.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Edit(
                                  id: _get[index]['id'],
                                )));
                  },
                  child: Card(
                    color: _lightColors[index % _lightColors.length],
                    child: Container(
                      constraints:
                          BoxConstraints(minHeight: (index % 2 + 1) * 85),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_get[index]['date']}',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${_get[index]['title']}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "Belum Ada Data Yang Tersedia",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 106, 137, 223),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Add()));
        },
      ),
    );
  }
}
