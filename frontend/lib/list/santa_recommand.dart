import 'package:flutter/material.dart';

class SantaRec extends StatefulWidget {
  @override
  _SantaRecState createState() => _SantaRecState();
}

class _SantaRecState extends State<SantaRec> {
  @override
  Widget build(BuildContext context) {
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
