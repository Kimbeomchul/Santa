import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:santa_front/provider/board_provider.dart';
import 'package:santa_front/model/board.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:santa_front/navigation/setting_menu.dart';
import 'package:santa_front/navigation/board_detail.dart';
import 'package:santa_front/navigation/board_write.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BoardListWidget extends StatefulWidget {
  BoardListWidget({Key key}) : super(key: key);

  @override
  _BoardListWidgetState createState() => _BoardListWidgetState();
}

class _BoardListWidgetState extends State<BoardListWidget> {
  SearchBar searchBar;
  String searchKey = "";

  BoardProvider _boardProvider;

  var _pageSize = 10;
  final PagingController<int, Board> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    print("initState() 실행 체크 ");
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView<int, Board>.separated(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Board>(
          itemBuilder: (context, item, index) => boardCard(context, item)
          ),
          separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      _boardProvider = Provider.of<BoardProvider>(context, listen: false);
      await _boardProvider.getBoardList(pageKey, _pageSize);
      List<Board> boardList = _boardProvider.boardList;

      final isLastPage = boardList.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(boardList);
      } else {
        final nextPageKey = pageKey + boardList.length;
        _pagingController.appendPage(boardList, nextPageKey);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }

  Widget boardCard(BuildContext context, item) {
    return Container(
      child: Card(
        elevation: 10,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BoardDetail())); // 게시판 상세페이지
          },
          child: imageRoute(item),
        ),
      ),
    );
  }

  Widget imageRoute(item) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 14, left: 10),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      image: DecorationImage(
                          image: AssetImage('images/santalogo.png'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(75.0)),
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
                    Text(item.user),
                    Text(
                      item.created,
                      style: TextStyle(color: Colors.grey),
                    ),
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
          child: Image.asset(
            'images/1.jpeg',
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" "),
            Text(
              item.user,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text("   "),
            Text(
              item.content,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.favorite_border,
              color: Colors.black,
              size: 20,
            ),
            Text(
              "  ",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.only(bottom: 10))
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(backgroundColor: Colors.cyan[600], actions: [
      searchBar.getSearchAction(context),
      PopupMenuButton<String>(
        icon: Icon(Icons.more_vert_rounded), // ...
        itemBuilder: (BuildContext context) {
          return Constants.choices.map((String choice) {
            return PopupMenuItem<String>(
              child: Text(choice),
              value: choice,
            );
          }).toList();
        },
        onSelected: choiceAction,
      )
    ]);
  }

  _BoardListWidgetState() {
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

  void choiceAction(String choice) {
    // 우측상단 메뉴 버튼
    if (choice == "팔로워글보기") {
      print("팔로워글 클릭됨");
    } else if (choice == "전체글보기") {
      print("전체글 클릭됨");
    } else if (choice == "내글보기") {
      print("내글 클릭됨");
    }
  }

  void onSubmitted(String value) {
    setState(() {
      searchKey = value;
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text('$value에대한 검색결과')));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
          appBar: searchBar.build(context),
          key: _scaffoldKey,
          body: _buildBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoardWrite())); // 글쓰기페이지로 이동
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.black,
          )),
    );

    // @override
    // void dispose() {
    //   _pagingController.dispose();
    //   super.dispose();
    // }
  }
}
