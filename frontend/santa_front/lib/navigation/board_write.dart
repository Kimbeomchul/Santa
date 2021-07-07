import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BoardWrite extends StatefulWidget {
  @override
  _BoardWriteState createState() => _BoardWriteState();
}

class _BoardWriteState extends State<BoardWrite> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          new IconButton(
            icon: new Icon(Icons.send),
            tooltip: 'Write',
            onPressed: sendBoard,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '제목',
                ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 30)),
            TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,//Normal textInputField will be displayed
                maxLines: 25,// when user presses enter it will adapt to it
                controller: contentController,
                decoration: InputDecoration(
                  labelText: '글내용',
                ),
            ),
          ],
        ),
      ),
    );
  }
  void sendBoard() async{
    SharedPreferences _prefs;
    _prefs ??= await SharedPreferences.getInstance();
    final token = _prefs.getString('Token') ?? 0;

    final response = await http.post(
      'http://127.0.0.1:8000/api/board/',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token " + token
      },
      body: jsonEncode(
        {
          "title": titleController.text,
          "content": contentController.text,
        }
      ),
    );
    if (response.statusCode == 201){
      Navigator.pop(context);
    }
    else {
      throw Exception('글 작성 실패');
    }
  }
}
