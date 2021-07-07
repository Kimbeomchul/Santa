import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:santa_front/model/board.dart';

class BoardRepository {
  // 장고 API로 호출해서 값을 받아오는 부분
  Future<List<Board>> getBoardList(
    int offset,
    int limit, {
    String searchTerm,
  }) async {
    SharedPreferences _prefs;
    _prefs ??= await SharedPreferences.getInstance();
    final token = _prefs.getString('Token') ?? 0;
    print(_ApiUrlBuilder().boardList(offset, limit, searchTerm: searchTerm));
    return http.get(
      _ApiUrlBuilder().boardList(offset, limit, searchTerm: searchTerm),
      headers: {
        "Accept": "application/json",
        "Authorization": "Token " + token,
      },
    ).mapFromResponse<List<Board>, List<dynamic>>(
      (jsonArray) => _parseItemListFromJsonArray(
        jsonArray,
        (jsonObject) => Board.fromJson(jsonObject),
      ),
    );
  }

  List<T> _parseItemListFromJsonArray<T>(
    List<dynamic> jsonArray,
    T Function(dynamic object) mapper,
  ) =>
      jsonArray.map(mapper).toList();

  // Future<List<Board>> loadBoardList() async {
  //   SharedPreferences _prefs;
  //   _prefs ??= await SharedPreferences.getInstance();
  //   final token = _prefs.getString('Token') ?? 0;

  //   var uri = Uri.http("127.0.0.1:8000", "/api/board/");
  //   var response = await http.get(
  //     uri,
  //     headers: {
  //       "Accept": "application/json",
  //       "Authorization": "Token " + token,
  //     },
  //   );
  //   if (response.body != null) {
  //     Map<String, dynamic> body = json.decode(response.body);
  //     if (body['results'] != null) {
  //       List<dynamic> list = body['results'];
  //       print("예전거------");
  //       return list.map<Board>((item) => Board.fromJson(item)).toList();
  //     }
  //   }
  // }
}

class _ApiUrlBuilder {
  String _baseUrl = "http://127.0.0.1:8000";
  String _charactersResource = "/api/board/";

  Uri boardList(
    int offset,
    int limit, {
    String searchTerm,
  }) =>
      Uri.parse(
        '$_baseUrl$_charactersResource?'
        'offset=$offset'
        '&limit=$limit'
        '${_buildSearchTermQuery(searchTerm)}',
      );

  String _buildSearchTermQuery(String searchTerm) =>
      searchTerm != null && searchTerm.isNotEmpty
          ? '&name=${searchTerm.replaceAll(' ', '+').toLowerCase()}'
          : '';
}

extension on Future<http.Response> {
  Future<R> mapFromResponse<R, T>(R Function(T) jsonParser) async {
    var response = await this;
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(utf8.decode(response.bodyBytes));
      
      // List<dynamic> list = body['results'];
      //     print("예전거------");
      //     return list.map<Board>((item) => Board.fromJson(item)).toList();
      return jsonParser(body['results']);
    }
    else {
      // 에러처리
    }
  }
}
