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
        child: Column(
          children: [
            TextField(
                controller: TitleController,
                decoration: InputDecoration(
                  labelText: '제목',
                ),
            ),
            TextField(
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
