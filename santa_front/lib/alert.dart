import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:santa_front/navigation_route.dart';

class AlertPage extends StatefulWidget {
  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return Scaffold(
      body: AlertDialog(
        title: new Text("Santa"),
        content: new Text("산 정보가 존재하지 않습니다."),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => NavigationRouter(),), (route) => false, ); //스택초기화 라우터
            },
          ),
        ],
      ),
    );
  }
}
