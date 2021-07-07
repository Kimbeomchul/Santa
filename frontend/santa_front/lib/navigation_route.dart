import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:santa_front/navigation/chat.dart';
import 'package:santa_front/ui/board_list_widget.dart';

import 'list/HomePage.dart';
import 'navigation/user_profile.dart';

class NavigationRouter extends StatefulWidget {
  @override
  _NavigationRouterState createState() => new _NavigationRouterState();
}

class _NavigationRouterState extends State<NavigationRouter> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex, // 현재 인덱스람지
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text('홈'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('커뮤니티'),
            icon: Icon(Icons.library_books_rounded),
          ),
          BottomNavigationBarItem(
            title: Text('채팅'),
            icon: Icon(Icons.chat_bubble),
          ),
          BottomNavigationBarItem(
            title: Text('프로필'),
            icon: Icon(Icons.account_box),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
        ),
    );
  }

  List _widgetOptions = [
    HomePage(), // 인덱스 0
    BoardListWidget(), // 인덱스 1
    UserChat(), // 인덱스 2
    UserProfile(), // 인덱스 3

  ];
}

// 반응형으로 제작한거 주석처리 API 호출이 너무많이됨

// import 'package:flutter/material.dart';
// import 'package:santa_front/navigation/chat.dart';
//
// import 'navigation/board_list.dart';
// import 'list/HomePage.dart';
// import 'navigation/user_profile.dart';
//
// class NavigationRouter extends StatefulWidget {
//   @override
//   _NavigationRouterState createState() => new _NavigationRouterState();
// }
//
// class _NavigationRouterState extends State<NavigationRouter> {
//   int _page = 0;
//   PageController _c;
//
//   @override
//   void initState(){
//     _c =  new PageController(
//       initialPage: _page,
//     );
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       bottomNavigationBar: new BottomNavigationBar(
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey.withOpacity(.60),
//         currentIndex: _page,
//         onTap: (index){
//           this._c.animateToPage(index,duration: const Duration(milliseconds: 300),curve: Curves.easeInOut);
//         },
//         items: <BottomNavigationBarItem>[
//           new BottomNavigationBarItem(icon: new Icon(Icons.home), title: new Text("홈")),
//           new BottomNavigationBarItem(icon: new Icon(Icons.library_books_rounded), title: new Text("커뮤니티")),
//           new BottomNavigationBarItem(icon: new Icon(Icons.chat_bubble), title: new Text("채팅")),
//           new BottomNavigationBarItem(icon: new Icon(Icons.account_box), title: new Text("프로필")),
//         ],
//
//       ),
//       body: new PageView(
//         controller: _c,
//         onPageChanged: (newPage){
//           setState((){
//             this._page=newPage;
//           });
//         },
//         children: <Widget>[
//           HomePage(), // 인덱스 0
//           BoardList(), // 인덱스 1
//           UserChat(), // 인덱스 2
//           UserProfile(), // 인덱스 3
//         ],
//       ),
//     );
//   }
// }

