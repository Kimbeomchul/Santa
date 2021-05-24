import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:santa_front/users/login.dart';
import 'package:provider/provider.dart';
import 'provider/AjaxProvider.dart';
import 'navigation_route.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AjaxProvider(),
        ),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
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
