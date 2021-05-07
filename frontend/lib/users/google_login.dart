import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginTest extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: GoogleLogin(),
    );
  }
}

class GoogleLogin extends StatefulWidget {
  const GoogleLogin({Key key}) : super(key: key);

  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
  void login() async {
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

  @override
  Widget build(BuildContext context) {
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
                child: Text("Login with Google"),
                onPressed: login,
            )
          ],
        ),
      ),
    );
  }
}
