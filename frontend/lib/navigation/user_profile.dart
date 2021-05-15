import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:santa_front/users/login.dart';

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
      print("NotKLogin");
    }
  }

  @override
  void initState(){
    super.initState();
    KakaoUser();
  }
 LogOut(){
   Navigator.of(context, rootNavigator: true).pop('dialog');  //취소
   if (LoginWith == 'Kakao') {
     LogOutUser(); // 카카오 로그아웃
   }else if(LoginWith == 'Google'){
     print("구글 로그아웃 구현하기 ");
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

// 유저 프로필 사진
  Widget _userImg(){
    if (profile != 'None') {
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
              image: NetworkImage(profile),
              fit: BoxFit.cover
          ),

        ),
      );
    }else{
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
              image: NetworkImage('https://blog.kakaocdn.net/dn/cyOIpg/btqx7JTDRTq/1fs7MnKMK7nSbrM9QTIbE1/img.jpg'),  //임시 투명이미지
              fit: BoxFit.cover
          ),

        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {


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
                Padding(padding: EdgeInsets.only(left: 10,top: 10,bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(nickname,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    Text(accountEmail,style: TextStyle(fontSize: 15),),
                  ],
                ),
                ),
                Divider(color:Colors.black),
              ],
            ),

          ),

        ],

      ),
        ),
    );
  }

}