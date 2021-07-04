import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:santa_front/navigation/board_detail.dart';
import 'package:santa_front/navigation/setting_menu.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'board_model.dart';
import 'board_write.dart';


// 커뮤니티 페이지


class BoardList extends StatefulWidget {
  @override
  _BoardListState createState() => _BoardListState();
}



class _BoardListState extends State<BoardList> {

  SearchBar searchBar;
  String searchKey = "";
  var boardlist;
  var morelist;

  var temp;
  Board board;
  List<Map> lists = [];
  Map<String,String> listmap ;
  var moreUrl;
  List<String> data = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Colors.cyan[600],
        actions: [
          searchBar.getSearchAction(context),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert_rounded), // 점세개
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  child: Text(choice),
                  value: choice,
                );
              }
              ).toList();
            },
            onSelected: choiceAction,
          ),

        ]);
  }

  Future getBoardList() async {
    SharedPreferences _prefs;
    _prefs ??= await SharedPreferences.getInstance();
    final token = _prefs.getString('Token') ?? 0;
    http.Response response = await http.get(
      Uri.encodeFull("http://127.0.0.1:8000/api/board/"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Token " + token,
      },
    );
    print(response.statusCode);
    boardlist = jsonDecode(response.body);
    print(boardlist);

    for(var i=0; i<10; i++){
      listmap = {
        "id" : "${boardlist['results'][i]['id']}",
        "user" : "${boardlist['results'][i]['user']}",
        "title" : "${boardlist['results'][i]['title']}",
        "content" : "${boardlist['results'][i]['content']}",
        "created_at" : "${boardlist['results'][i]['created_at']}",
        "modified_at" : "${boardlist['results'][i]['modified_at']}",
      };
      print("${boardlist['results'][i]}");
      lists.add(listmap);
    }
    return boardlist;
  }

  void choiceAction(String choice) {
    // 우측상단 메뉴버튼
    if (choice == "팔로워글보기") {
      print("팔로워글 클릭됨");
    } else if (choice == "전체글보기") {
      print("전체글 클릭됨");
    } else if (choice == "내글보기") {
      print("내글 클릭됨");
    }
    //print(choice);
  }

  void onSubmitted(String value) {
    setState(() {
      searchKey = value;
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text('$value에대한 검색결과')));
    });
  }

  _BoardListState() {
    searchBar = new SearchBar(

        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return WillPopScope(
      child: Scaffold(
        appBar: searchBar.build(context),

        key: _scaffoldKey,
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => BoardWrite())); // 글쓰기페이지로 이동
          },
          child: Icon(Icons.add, color: Colors.white,),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }


  Widget _buildBody() {
//  if (게시판 글 수 .length != 0) {
//     return ListView.builder(
//       padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
//       itemBuilder: board_list,
//       itemCount 10,
//
//     );

    return FutureBuilder(
        future: getBoardList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16, left: 10, right: 10),
            itemBuilder: board_list,
            itemCount: 10,

          );

        });
  }

  Widget board_list(BuildContext context, int index) {
    if(index <10) {
      return Container(
        child: Card(
          elevation: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => BoardDetail())); // 게시판 상세페이지
            },
            child: image_route(index),
          ),


        ),
      );
    }
  }


  Widget image_route(int index) {
    var imgUrl = "0";

//${snapshot.data['id']}
    if (imgUrl != "1") {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 14, left: 10),
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                            image: AssetImage('images/santalogo.png'),
                            fit: BoxFit.cover),
                        borderRadius:
                        BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 3.0, color: Colors.black)
                        ]),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  //눌렀을시 뜰 프로필 팝업
                },
                child: Container(
                  padding: EdgeInsets.only(top: 15, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lists[index]['user']),
                      Text(lists[index]['created_at'], style: TextStyle(color: Colors.grey),),
                    ],
                  ),

                ),
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.only(top: 20, bottom: 10),
            width: 420,
            height: 300,
            child: Image.asset('images/1.jpeg', fit: BoxFit.cover,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(" "),
              Text(lists[index]['user'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
              Text("   "),
              Text(lists[index]['content'], style: TextStyle(fontSize: 15),),

            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Icon(Icons.favorite_border, color: Colors.black, size: 20,),

              Text("  ", style: TextStyle(fontSize: 15),),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 10))

        ],
      );
    } else {
      return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 14, left: 10),
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                  image: AssetImage('images/santalogo.png'),
                                  fit: BoxFit.cover),
                              borderRadius:
                              BorderRadius.all(Radius.circular(75.0)),
                              boxShadow: [
                                BoxShadow(blurRadius: 3.0, color: Colors.black)
                              ]),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //눌렀을시 뜰 프로필 팝업
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 15, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lists[index]['user']),
                            Text(lists[index]['created_at'],
                              style: TextStyle(color: Colors.grey),),

                          ],
                        ),

                      ),
                    ),
                  ],
                ),

                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("   ", style: TextStyle(fontSize: 15),),
                    Text(lists[index]['content'],
                      style: TextStyle(fontSize: 15),),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Icon(Icons.favorite_border, color: Colors.black, size: 20,),

                    Text("  ", style: TextStyle(fontSize: 15),),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 10)),
                // Text(indexOf as String),
                // IconButton(icon: Icon(Icons.email), onPressed: (){
                //   more(index);
                // }),
              ],
            );
    }
  }
}