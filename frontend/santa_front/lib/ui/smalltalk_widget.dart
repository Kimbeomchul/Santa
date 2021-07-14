import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SmallTalkWidget extends StatefulWidget {
  @override
  _SmallTalkWidgetState createState() => _SmallTalkWidgetState();
}

class _SmallTalkWidgetState extends State<SmallTalkWidget> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
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
