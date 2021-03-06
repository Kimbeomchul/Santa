import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:santa_front/ui/login_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {



  @override
  _UserProfileState createState() => _UserProfileState();
}



class _UserProfileState extends State<UserProfile> {
  String provider = 'None';
  String name = 'None';
  String photo = 'None';
  String email = 'None';

  SharedPreferences _prefs;
  Future<bool> user() async {
    _prefs ??= await SharedPreferences.getInstance();
    setState(() {
      provider = (_prefs.getString('Provider') ?? '');
      name = (_prefs.getString('Name') ?? '');
      photo = (_prefs.getString('Photo') ?? '');
      email = (_prefs.getString('Email') ?? '');
    });
    // print(googleNickname);
    // print(googleImg);
    // print(googleEmail);
    // print(googleId);
    // if (provider == 'Kakao'){
    //   KakaoUser();
    // }
  }
//카카오 유저 정보 가져오기
//   Future KakaoUser() async {
//     try {
//       User user = await UserApi.instance.me(); // 유저정보
//    //   print(user.toString());
//       setState(() {
//         provider = 'Kakao';
//         accountEmail = user.kakaoAccount.email;
//         ageRange = user.kakaoAccount.ageRange.toString();
//         gender = user.kakaoAccount.gender.toString();
//         nickname =user.kakaoAccount.profile.nickname;
//         profile = user.kakaoAccount.profile.profileImageUrl.toString();
//       });
//
//     } catch (e) {
//       print("Google & Kakao Login Error ");
//     }
//   }

  @override
  void initState(){
    super.initState();
    user();  //
  }
 logOut(){
   Navigator.of(context, rootNavigator: true).pop('dialog');  //취소
   if (provider == 'kakao') {
     logOutUser(); // 카카오 로그아웃
     _prefs.clear(); // SharedPrefer 키값 전부 삭 제 !
   }else if(provider == 'google'){
     final GoogleSignIn _googleSignIn = new GoogleSignIn();
     _googleSignIn.signOut();
     _prefs.clear(); // SharedPrefer 키값 전부 삭 제 !
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginWidget(),), (route) => false, ); //스택초기화 라우터
   }else{
     print("세션에러");
   }
 }

  logOutUser() async {   // 로그아웃 로직
      try {
        var code = await UserApi.instance.logout();
        print(code.toString());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginWidget(),), (route) => false, ); //스택초기화 라우터
      } catch (e) {
        print("로그아웃 실패 : $e");
      }
  }


  Widget stats(String statName, int statCount) { // 팔로우 포스트 팔로일 
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 5)),
        Text(
          statCount.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        Padding(padding: EdgeInsets.only(top: 5)),
        Text(statName),
      ],
    );
  }
  Widget _userText(){
    String _curId = name;
    String _curEmail = email;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(_curId,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
        Text(_curEmail,style: TextStyle(fontSize: 15),),
      ],
    );


  }
// 유저 프로필 사진
   Widget _userImg() {
     String _curImg = photo;
      if(_curImg == "None"){
        return CircularProgressIndicator();
      }
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500],
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1.0,
            ),
          ],
          shape: BoxShape.circle,

          image: DecorationImage(
              image: NetworkImage(_curImg),
              fit: BoxFit.cover
          ),

        ),
      );
   }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정

    return WillPopScope(
      onWillPop: () {
        return;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Text("Santa Application  ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      icon: Icon(Icons.share),
                      color: Colors.black,
                      onPressed: null
                  ),
                  IconButton(
                      icon: Icon(Icons.logout),
                      color: Colors.black,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text('로그아웃 하시겠습니까?'),
                              actions: [
                                FlatButton(
                                  onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),  //취소
                                  child: Text('취소'),
                                ),
                                FlatButton(
                                  onPressed: () => logOut(), // passing true
                                  child: Text('로그아웃'),
                                ),
                              ],
                            );
                          }),
                  ),
                ],

              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.only(left: 5),
                  child : Row(
                    children: [
                      _userImg(),
                      Column(
                        children: [
                          Row(
                            children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(left: 40)),
                                    stats('게시물', 20),
                                    Padding(padding: EdgeInsets.only(left: 35)),
                                    stats('팔로워', 111),
                                    Padding(padding: EdgeInsets.only(left: 35)),
                                    stats('팔로잉', 203),
                                  ],
                                ),

                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Padding(padding: EdgeInsets.only(top:20,left: 50)), // 사진과 이외의 거리
                          //     Text('게시글'),
                          //     Padding(padding: EdgeInsets.only(left: 30)), // 사진과 이외의 거리
                          //     Text('팔로우'),
                          //     Padding(padding: EdgeInsets.only(left: 30)), // 사진과 이외의 거리
                          //     Text('좋아요'),
                          //   ],
                          // ),

                        ],
                      ),

                    ],
                  ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(padding: EdgeInsets.only(left: 10,top: 10,bottom: 10),
                    child: _userText(), // 유저 아이디 , 이메일
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 350,
                        child:  OutlinedButton(
                          onPressed: () {},
                          child: Text('내정보 수정',
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),

                    ],
                  ),
                  Divider(color:Colors.black,thickness: 1,),

                  // 디바이더 이후
                  // 에타형식

                // profileList(), // 내글

                ],
              ),

            ),

          ],
      ),
        ),
    );
  }

}