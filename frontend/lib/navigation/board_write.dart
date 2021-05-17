import 'package:flutter/material.dart';


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
            onPressed: () => {   // 글쓴내용 보여주는 임시 로직
              showDialog(
                  context:context,
                  builder:(context) {
                    return Column(
                      children: [
                        AlertDialog(content: Text(TitleController.text)),
                        AlertDialog(content: Text(ContentController.text)),
                      ],
                    );
                  }
              ),
            },
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
}
