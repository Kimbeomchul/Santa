import 'package:flutter/material.dart';

class UserChat extends StatefulWidget {
  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("채팅"),
        ],
      ),
    );
  }
}