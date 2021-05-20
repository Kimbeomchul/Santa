import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:santa_front/navigation/board_detail.dart';

import 'board_write.dart';


// 커뮤니티 페이지


class BoardList extends StatefulWidget {
  @override
  _BoardListState createState() => _BoardListState();
}



class _BoardListState extends State<BoardList> {
  SearchBar searchBar;
  String searchKey = "";
  List<String> data = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        actions: [searchBar.getSearchAction(context)]);
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return WillPopScope(
        child: Scaffold(
          appBar: searchBar.build(context),

          key: _scaffoldKey,
      body: _buildBody(),
       floatingActionButton: FloatingActionButton(
         onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => BoardWrite())); // 글쓰기페이지로 이동
         },
         child: Icon(Icons.add, color: Colors.white,),
         backgroundColor: Colors.black,
       ),
        ),
    );
  }


}
Widget _buildBody() {
//  if (게시판 글 수 .length != 0) {
    return ListView.builder(

      padding: const EdgeInsets.only(top: 16,left: 10, right: 10),
      itemBuilder: board_list,
      itemCount: 10,
    );
  }

Widget board_list(BuildContext context, int index) {
  return Container(
    child: Card(
//                color: Colors.blue,

      elevation: 10,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BoardDetail())); // 게시판 상세페이지
        },
        child: Column(
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
                    padding: EdgeInsets.only(top: 15 ,left:10),
                    child: Column(
                      children: [
                        Text('산타'),
                        Text('5분전',style: TextStyle(color: Colors.grey),),
                      ],
                    ),

                  ),
                ),
              ],
            ),

              Container(
                padding: EdgeInsets.only(top: 20,bottom: 10),
                width: 420,
                height: 300,
                child: Image.asset('images/1.jpeg',fit: BoxFit.cover,),
              ),

           Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(" 산타",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                  Text("  아찔한 진자운동을 하였다.",style: TextStyle(fontSize: 15),),

                ],
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Icon(Icons.favorite_border,color: Colors.black, size: 20 ,),

                Text("  ",style: TextStyle(fontSize: 15),),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10))

          ],
        ),
      ),


    ),
  );
}