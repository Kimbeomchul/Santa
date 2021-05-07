import 'package:flutter/material.dart';
import 'package:santa_front/users/login.dart';

import 'users/google_login.dart';
import 'navigation_route.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Santa',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: KakaoLogin(),
    );
  }
}
