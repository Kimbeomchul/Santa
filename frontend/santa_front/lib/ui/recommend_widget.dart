import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecommendWidget extends StatefulWidget {
  @override
  _RecommendWidgetState createState() => _RecommendWidgetState();
}

class _RecommendWidgetState extends State<RecommendWidget> {

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
