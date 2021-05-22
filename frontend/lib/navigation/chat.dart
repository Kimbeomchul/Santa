import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserChat extends StatefulWidget {
  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {

  profileList(){
    return ListView.builder(

      padding: const EdgeInsets.only(top: 16,left: 10, right: 10),
        itemBuilder: lists,
        itemCount: 4,

    );
  }

  Widget lists(BuildContext context, int index) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top:10,)),
          Text('산에 가고싶은 날이네요..',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.5),),
          Text('오늘 날씨가 좋아서 산에가고싶었지만 못갔슴다. 커피마시고파여 '),
          Row(
            children: [
              Text('5분 전',style: TextStyle(fontSize: 11),),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return WillPopScope(
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan[600],
            title: Text("CHATTIIINGGGG"),
          ),
         body:
         profileList(),
        ),
    );
  }
}