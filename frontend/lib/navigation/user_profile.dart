import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:santa_front/users/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {



  @override
  _UserProfileState createState() => _UserProfileState();
}



class _UserProfileState extends State<UserProfile> {
  String accountEmail = 'None';
  String ageRange = 'None';
  String gender = 'None';
  String profile = 'None';
  String userId = 'None';
  String nickname = 'None';
  String LoginWith = '';

  var googleEmail;
  var googleId;
  var googleImg;
  var googleNickname;
  SharedPreferences _prefs;
  Future<bool> googleUser() async {
    _prefs ??= await SharedPreferences.getInstance();
    setState(() {
      LoginWith = (_prefs.getString('LoginWith') ?? 'Kakao');
      googleNickname = (_prefs.getString('googleNickname') ?? '');
      googleImg = (_prefs.getString('googleImg') ?? '');
      googleEmail = (_prefs.getString('googleEmail') ?? '');
      googleId = (_prefs.getString('googleId') ?? '');
    });
    // print(googleNickname);
    // print(googleImg);
    // print(googleEmail);
    // print(googleId);
    if (LoginWith == 'Kakao'){
      KakaoUser();
    }
  }
//카카오 유저 정보 가져오기
  Future KakaoUser() async {
    try {
      User user = await UserApi.instance.me(); // 유저정보
   //   print(user.toString());
      setState(() {
        LoginWith = 'Kakao';
        accountEmail = user.kakaoAccount.email;
        ageRange = user.kakaoAccount.ageRange.toString();
        gender = user.kakaoAccount.gender.toString();
        nickname =user.kakaoAccount.profile.nickname;
        profile = user.kakaoAccount.profile.profileImageUrl.toString();
      });

    } catch (e) {
      print("Google & Kakao Login Error ");
    }
  }

  @override
  void initState(){
    super.initState();
    googleUser();  //
  }
 LogOut(){
   Navigator.of(context, rootNavigator: true).pop('dialog');  //취소
   if (LoginWith == 'Kakao') {
     LogOutUser(); // 카카오 로그아웃
   }else if(LoginWith == 'Google'){
     final GoogleSignIn _googleSignIn = new GoogleSignIn();
     _googleSignIn.signOut();
     _prefs.clear(); // SharedPrefer 키값 전부 삭 제 !
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => KakaoLogin(),), (route) => false, ); //스택초기화 라우터
   }else{
     print("세션에러");
   }
 }

  LogOutUser() async {   // 로그아웃 로직
      try {
        var code = await UserApi.instance.logout();
        print(code.toString());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => KakaoLogin(),), (route) => false, ); //스택초기화 라우터
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
    var _curId = '';
    var _curEmail ='';
    if (LoginWith == 'Kakao') {
      _curId = nickname;
      _curEmail = accountEmail;
    }else if (LoginWith == 'Google'){
      _curId = googleNickname;
      _curEmail = googleEmail;
    }
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
    var _curImg ='https://blog.kakaocdn.net/dn/cyOIpg/btqx7JTDRTq/1fs7MnKMK7nSbrM9QTIbE1/img.jpg';
    if (LoginWith == 'Kakao') {
      _curImg = profile;
    }else if (LoginWith == 'Google'){
      _curImg = googleImg;
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

 profileList(){
    return Container(
      height: 400,
      width: 450,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: lists,
        itemCount: 10,
      ),
    );
 }

  Widget lists(BuildContext context, int index) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top:10,)),
            Text('산에 가고싶은 날이네요..',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.5),),
            Text('오늘 날씨가 좋아서 산에가고싶었지만 못갔슴다. 커피마시고파여 '),
            Row(
              children: [
                Text('5분 전',style: TextStyle(fontSize: 11),),
              ],
            ),
            Divider(),
          ],
        ),
    );
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정

    return WillPopScope(
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
                                onPressed: () => LogOut(), // passing true
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

                profileList(), // 내글

              ],
            ),

          ),

        ],

      ),
        ),
    );
  }

}