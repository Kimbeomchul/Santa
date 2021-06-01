import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:santa_front/provider/board_provider.dart';
import 'package:santa_front/model/board.dart';

class BoardListWidget extends StatelessWidget {
  BoardListWidget({Key key}) : super(key: key);
  BoardProvider _boardProvider;

  Widget _makeListView(List<Board> boardList){
    return ListView.separated(
      itemCount: boardList.length,
      itemBuilder: (BuildContext context, int index){
        return Center(
          child: Text(boardList[index].title),
        );
      },
      separatorBuilder: (BuildContext context, int index){
        return Divider();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _boardProvider = Provider.of<BoardProvider>(context, listen: false);
    _boardProvider.loadBoardList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Test 게시판"),
        ),
        body: Consumer<BoardProvider>(
          builder: (context, provider, widget) {
            print(provider.boardList);
            if (provider.boardList != null && provider.boardList.length > 0) {
              return _makeListView(provider.boardList);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        )
    );
  }
}
