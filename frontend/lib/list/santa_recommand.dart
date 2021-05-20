import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SantaRec extends StatefulWidget {
  @override
  _SantaRecState createState() => _SantaRecState();
}

class _SantaRecState extends State<SantaRec> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("산타의 추천"),
        ],
      ),
    );
  }
}
