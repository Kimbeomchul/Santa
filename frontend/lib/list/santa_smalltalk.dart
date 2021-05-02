import 'package:flutter/material.dart';

class SmallTalk extends StatefulWidget {
  @override
  _SmallTalkState createState() => _SmallTalkState();
}

class _SmallTalkState extends State<SmallTalk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
      children: [
        Image.asset('images/santalogo.png'),
        Text(' 산타의 한마디 : 나는야 산타는 산타 싸ㅏㅏㅏㅏㄴ타~', style: TextStyle(fontSize: 20),)

      ],

      ),

    );
  }
}
