import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:google_sign_in/google_sign_in.dart';

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


  bool _isKakaoTalkInstalled = false; // 카카오톡 설치여부 bool


  // 구글 로그인  -- Start
  void LoginWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // you can add extras if you require
      ],
      clientId: 'AIzaSyAVw5ZxEo5vyt1Qry7BNyFIZGMHgeP5Vjk',
    );


    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      GoogleSignInAuthentication auth = await acc.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);

      acc.authentication.then((GoogleSignInAuthentication auth) async {
        print(auth.idToken);
        print(auth.accessToken);
      });
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
                child: Text("카카오톡 로그인"),
                onPressed:
                _isKakaoTalkInstalled ? _loginWithTalk : _loginWithKakao),
            RaisedButton(
                child: Text("구글 로그인 "),
                onPressed:LoginWithGoogle,
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
