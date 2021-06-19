import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:santa_front/model/board.dart';
import 'package:santa_front/repository/board_repository.dart';

class BoardProvider extends ChangeNotifier{
  BoardRepository _boardRepository = BoardRepository();

  List<Board> _board = [];
  List<Board> get boardList => _board;
  loadBoardList() async{
    List<Board> boardList = await _boardRepository.loadBoardList();
    _board = boardList;
    notifyListeners();
  }
    // repository
}
