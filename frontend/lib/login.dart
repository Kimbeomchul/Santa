import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';

class KakaoLoginTest extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = 'c03a985376702fe2cbf7fab36e33e0fd';

    return MaterialApp(
      home: KakaoLogin(),
    );
  }
}

class KakaoLogin extends StatefulWidget {
  KakaoLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _KakaoLoginState createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  bool _isKakaoTalkInstalled = false;

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
    //
    // if (_isKakaoTalkInstalled.toString() == "true"){
    //   _loginWithTalk();
    // }else if(_isKakaoTalkInstalled.toString() =="false"){
    //   _loginWithKakao();
    // }else{
    //   print("카카오톡 설치여부 분기에러 ");
    // }
  }

  _issueAccessToken(String authCode) async {
    try {

      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print(token);
      // var code = await AuthCodeClient.instance.requestWithTalk();
      //print(code + ' == KAKAO AUTH TOKEN');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginDone()),
      );
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

    return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Kakao Flutter SDK Login"),
    //     actions: [],
    //   ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 50),),
            RaisedButton(
                child: Text("Login with Talk"),
                onPressed:
                _isKakaoTalkInstalled ? _loginWithTalk : _loginWithKakao),
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

class LoginDone extends StatelessWidget {
  Future<bool> _getUser() async {
    try {
      User user = await UserApi.instance.me(); // 유저정보
      print(user.toString());
    } on KakaoAuthException catch (e) {
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUser();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text('Login Success!'),
        ),
      ),
    );
  }
}
