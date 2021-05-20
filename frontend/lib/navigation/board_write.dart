import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class BoardWrite extends StatefulWidget {
  @override
  _BoardWriteState createState() => _BoardWriteState();
}

class _BoardWriteState extends State<BoardWrite> {
  final TitleController = TextEditingController();
  final ContentController = TextEditingController();

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
                controller: TitleController,
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
                controller: ContentController,
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
    final response = await http.post(
      'http://127.0.0.1:8000/api/board/',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Token 38a6cd7b9a38596ca688a6bcacd578aec90ba31e"
      },
      body: jsonEncode(
        {
          "title": TitleController.text,
          "content": ContentController.text,
        }
      ),
    );
    print(response.statusCode);
  }
}
