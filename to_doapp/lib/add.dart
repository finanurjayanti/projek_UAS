import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _fromkey = GlobalKey<FormState>();

  var title = TextEditingController();
  var content = TextEditingController();

  Future _onSubmit() async {
    try {
      return await http.post(
        Uri.parse("http://localhost/latihan/note_app/create.php"),
        body: {
          "title": title.text,
          "content": content.text,
        },
      ).then((value) {
        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Catatan Baru"),
      ),
      body: Form(
        key: _fromkey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Judul :',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: title,
                decoration: InputDecoration(
                    hintText: "Ketikan Judul Catatan Di sini!",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Color.fromARGB(255, 106, 137, 223),
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Note Title is Required!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Catatan :',
                style: TextStyle(
                  color: Color.fromARGB(255, 248, 248, 248),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: content,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Ketikan Catatan Disini!',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Color.fromARGB(255, 106, 137, 223),
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Note Content is Required!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Tambah",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (_fromkey.currentState!.validate()) {
                    _onSubmit();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
