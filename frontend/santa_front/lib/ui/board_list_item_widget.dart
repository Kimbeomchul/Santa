import 'package:santa_front/model/board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BoardListItem extends StatelessWidget {
  const BoardListItem({
    @required this.boardList,
    Key key,
  }) : super(key: key);

  final Board boardList;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(
          radius: 20,
        ),
        title: Text(boardList.title),
      );
}
