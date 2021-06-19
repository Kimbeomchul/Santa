import 'dart:convert';
import 'package:santa_front/model/board.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class BoardRepository{
  // 장고 API로 호출해서 값을 받아오는 부분

  Future<List<Board>> loadBoardList() async{
    SharedPreferences _prefs;
    _prefs ??= await SharedPreferences.getInstance();
    final token = _prefs.getString('Token') ?? 0;

    var uri = Uri.http("127.0.0.1:8000", "/api/board/");
    var response = await http.get(
      uri,
      headers: {
        "Accept": "application/json",
        "Authorization": "Token " + token,
      },
    );
    if(response.body != null){
      Map<String, dynamic> body = json.decode(response.body);
      if(body['results'] != null){
        List<dynamic> list = body['results'];

        return list.map<Board>((item) => Board.fromJson(item)).toList();
      }
    }
  }
}