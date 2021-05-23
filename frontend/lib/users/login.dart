import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../navigation_route.dart';

class KakaoLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    KakaoContext.clientId = 'c03a985376702fe2cbf7fab36e33e0fd';

    return MaterialApp(
      home: LoginPage(),
    );
  }
}


class LoginPage extends StatefulWidget {

  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var googleEmail;
  var googleId;
  var googleImg;
  var googleNickname;
  SharedPreferences _prefs;

  bool _isKakaoTalkInstalled = false; // 카카오톡 설치여부 bool


  // 구글 로그인  -- Start


   LoginWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
      clientId: 'AIzaSyAVw5ZxEo5vyt1Qry7BNyFIZGMHgeP5Vjk',
    );


    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      GoogleSignInAuthentication auth = await acc.authentication;
      if(acc.id != null || acc.email != null || acc.photoUrl != null){
        // _prefs.setString('googleId', acc.id);
        // _prefs.setString('googleEmail', acc.email);
        // _prefs.setString('googleImg', acc.photoUrl);
        _prefs ??= await SharedPreferences.getInstance();
        await _prefs.setString('googleNickname', acc.displayName);
        await _prefs.setString('googleImg', acc.photoUrl);
        await _prefs.setString('googleEmail', acc.email);
        await _prefs.setString('googleId', acc.id);
        await _prefs.setString('LoginWith', 'Google');

        // googleNickname = (_prefs.getString('googleNickname') ?? '');
        // print(googleNickname);
        // googleImg = (_prefs.getString('googleImg') ?? '');
        // print(googleImg);
        // googleEmail = (_prefs.getString('googleEmail') ?? '');
        // print(googleEmail);
        // googleId = (_prefs.getString('googleId') ?? '');
        // print(googleId);

      }


      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);

        final response = await http.post(
          'http://127.0.0.1:8000/dj-rest-auth/google/',
          headers: {
            "Content-Type": "application/json",
            'Accept': 'application/json',
          },
          body: jsonEncode(
            {
              "access_token": auth.accessToken,
              "code": '',
              "id_token": auth.idToken,
            }
          ),
        );
        if (response.statusCode == 200){
          print(response);
          print(jsonDecode(response.body)['key']);
          await _prefs.setString('Token', jsonDecode(response.body)['key']);
          final token = _prefs.getString('Token') ?? 0;
          final responseUser = await http.get(
            'http://127.0.0.1:8000/api/users/',
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Token " + token
            }
          );
          if(responseUser.statusCode == 200){
            var userData = jsonDecode(utf8.decode(responseUser.bodyBytes))[0];
            await _prefs.setString('Username', userData['username']);
            await _prefs.setString('Name', userData['name']);
            await _prefs.setString('Email', userData['email']);
            await _prefs.setString('Provider', userData['provider']);
            await _prefs.setString('Photo', userData['photo']);
          }
        }
        else{
          throw Exception('구글 로그인 실패');
        }

      });

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => NavigationRouter(),), (route) => false, ); //스택초기화 라우터
    });

  }


  // 구글 로그인 -- End





  // 카카오 로그인 -- Start
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled(); //카카오톡 설치여부 체크
    print('카카오톡 설치여부 : ' + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }
    //
    // if (_isKakaoTalkInstalled.toString() == "true"){
    //   _loginWithTalk();
    // }else if(_isKakaoTalkInstalled.toString() =="false"){
    //   _loginWithKakao();
    // }else{
    //   print("카카오톡 설치여부 분기에러 ");
    // }


  _issueAccessToken(String authCode) async {
    try {

      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print(token);
      // var code = await AuthCodeClient.instance.requestWithTalk();
      //print(code + ' == KAKAO AUTH TOKEN');

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => NavigationRouter(),), (route) => false, ); //스택초기화 라우터
    } catch (e) {
      print("토큰 획득실패 _issueAccessToken() : $e");
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request(); // 카카오톡 웹로그인
      await _issueAccessToken(code);
      print(code + ' == KAKAO AUTH TOKEN WEB');
    } catch (e) {
      print("WEB LOGIN ERROR = _loginWithKakao() : $e");
    }
  }

  _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk(); // 카카오톡 로그인
      await _issueAccessToken(code);
      print(code + ' == KAKAO AUTH TOKEN TALK');
    } catch (e) {
      print("TALK LOGIN ERROR = _loginWithTalk() : $e");
    }
  }

  logOutTalk() async {   // 로그아웃 로직
    try {
      var code = await UserApi.instance.logout();
      print(code.toString());
    } catch (e) {
      print("로그아웃 실패 : $e");
    }
  }

  unlinkTalk() async {
    try {
      var code = await UserApi.instance.unlink();
      print(code.toString());
    } catch (e) {
      print(e);
    }
  }
  // 카카오 로그인 End


  // 카카오톡 로그인 세션유지중인지 확인하는 토큰체커 코드
  // AccessToken token = await AccessTokenStore.instance.fromStore();
  // if (token.refreshToken == null) {
  // Navigator.of(context).pushReplacementNamed('/login');
  // } else {
  // Navigator.of(context).pushReplacementNamed("/main");
  // }

  @override
  Widget build(BuildContext context) {
    isKakaoTalkInstalled();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return Scaffold(
      //   appBar: AppBar(
      //     title: Text("Kakao Flutter SDK Login"),
      //     actions: [],
      //   ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Container(
              child:
              Image.asset('images/Design.jpeg' ,fit: BoxFit.cover,),
            ),
            Padding(padding: EdgeInsets.only(top: 100),),

            GestureDetector(
              child:
              Image.asset('images/loginK.png' ,fit: BoxFit.cover,),
              onTap: _isKakaoTalkInstalled ? _loginWithTalk : _loginWithKakao,
            ),
            GestureDetector(
              child:
              Image.asset('images/loginG.png' ,fit: BoxFit.cover,),
              onTap: LoginWithGoogle,
            ),
            RaisedButton(
              child: Text("Logout"),
              onPressed: logOutTalk,
            )
          ],
        ),
      ),
    );
  }
}

