import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:santa_front/list/maps.dart';
import 'package:santa_front/list/weather.dart';
import 'package:santa_front/mountain/mt_info.dart';
import 'package:santa_front/navigation/aboutus.dart';
import 'package:santa_front/navigation/board_list.dart';
import 'package:santa_front/main.dart';
import 'package:santa_front/list/santa_recommand.dart';
import 'package:santa_front/list/santa_smalltalk.dart';
import 'package:http/http.dart' as http;
import 'package:santa_front/users/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final mycontroller = TextEditingController();
  FocusNode myFocusNode;

  bool gps;
  var weatherData;



  String url = 'http://api.openweathermap.org/data/2.5/weather?';
  String lat = '';
  String lon = '';
  String appId = 'appid=8cdd068d54bf1713cb88cb026decbf95&';
  String units = 'units=metric';



  String _accountEmail = 'None';
  String _ageRange = 'None';
  String _gender = 'None';
  String _profile = 'None';
  String _userId = 'None';
  String _nickname = 'None';
  String LoginWith = '';

  var googleEmail;
  var googleId;
  var googleImg;
  var googleNickname;
  SharedPreferences _prefs;
  Future<bool> googleUser() async {
    _prefs ??= await SharedPreferences.getInstance();
    googleNickname = (_prefs.getString('googleNickname') ?? '');
    googleImg = (_prefs.getString('googleImg') ?? '');
    googleEmail = (_prefs.getString('googleEmail') ?? '');
    googleId = (_prefs.getString('googleId') ?? '');
    LoginWith = (_prefs.getString('LoginWith') ?? 'Kakao');
    // print(googleNickname);
    // print(googleImg);
    // print(googleEmail);
    // print(googleId);
  }

  _drawerInfo(){
    var _currentImg = '';
    var _currentId = '';
    var _currentEmail = 'https://blog.kakaocdn.net/dn/cyOIpg/btqx7JTDRTq/1fs7MnKMK7nSbrM9QTIbE1/img.jpg' ;

    if(LoginWith == "Google"){
      _currentImg = googleImg;
      _currentEmail = googleEmail;
      _currentId = googleNickname;
    }else if (LoginWith == "Kakao"){
      _currentImg = _profile;
      _currentEmail = _accountEmail;
      _currentId = _nickname;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width:70,
          height:70,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage(_currentImg),
                  fit: BoxFit.cover)
          ),
        ),
        Padding(padding: EdgeInsets.only(left:20,top:15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_currentId,
                style: TextStyle(
                    fontSize: 18,
                    color:Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
              Text(_currentEmail,style: TextStyle(
                  color: Colors.black
              ),),
            ],
          ),
        ),
      ],
    );

  }

 // 로그아웃 구현
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

//카카오 유저 정보 가져오기
  Future _KakaoUser() async {
    try {
      User user = await UserApi.instance.me(); // 유저정보
    //  print(user.toString());
      setState(() {
        LoginWith = 'Kakao';
        _accountEmail = user.kakaoAccount.email;
        _ageRange = user.kakaoAccount.ageRange.toString();
        _gender = user.kakaoAccount.gender.toString();
        _nickname =user.kakaoAccount.profile.nickname;
        _profile = user.kakaoAccount.profile.profileImageUrl.toString();
        _userId = user.id.toString(); //유저아이디

      });

    } catch (e) {
      print("Error With KakaoUserInfo");
    }
  }

  void permission()async{ // 위치권환 획득 < 날씨 >
    await requestPermission();
    var value = await checkPermission();
    setState(() {
      if(value == LocationPermission.always || value == LocationPermission.whileInUse){
        gps = true;
        print("Geo value Success");
      }else{
        gps = false;
        print(value); // 권한값 확인
      }
    });
  }

  LogOutUser() async {   // 로그아웃 로직
    if(_nickname != 'None'){
      try {
        var code = await UserApi.instance.logout();
        print(code.toString());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => KakaoLogin(),), (route) => false, ); //스택초기화 라우터
      } catch (e) {
        print("로그아웃 실패 : $e");
      }
    }else{
      print('Err LogOutUser');
    }
  }

  Future<Null> _onRefresh()async{ // Drawer
    setState(() {

    });
  }

  Future getData()async{
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   // print(position);
    lat = "lat=" + position.latitude.toString() + '&';
    lon = "lon=" + position.longitude.toString() + '&';

    http.Response response = await http.get(
      Uri.encodeFull(url+lat+lon+appId+units),
      headers:  {"Accept" : "application/json"},

    );
    //print(url+lat+lon+appId+units);
    // print("ResponseBody : ${response.body}");
    weatherData = jsonDecode(response.body);

    // if(weatherData['main']['temp']< 15){
    //   print('추웡');
    // }else{
    //   print("더웡");
    // }

    return weatherData;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permission(); // 날씨권
    _KakaoUser(); // 카카오 로그인
    googleUser(); // 구글로그인
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
      key: scaffoldKey,
      drawer : _drawer(),

      //appBar: buildAppBar(),
      body: _buildBody(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo())); // 글쓰기페이지로 이동
      //   },
      //   child: Icon(Icons.add, color: Colors.white,),
      //   backgroundColor: Colors.black,
      // ),
    ),
    );
  }

  /*
  buildAppBar() {
    return AppBar(
      title: Text('HomePage'),
    );
  }
*/
  _drawer(){
    FocusScope.of(context).requestFocus(new FocusNode()); // 포커스 삭제
    return Drawer(
      child:  ListView(
        padding:  EdgeInsets.zero,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              children: [
                Text("Santa Application",
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
              ],

            ),
          ),
          Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _drawerInfo(),   // Drawer Login User Info

                  SizedBox(
                   height: 10,
                  ),

                Divider(color:Colors.black,thickness: 0.5,),
                  ListTile(
                    leading:Icon(Icons.settings),
                    title:Text("설정"),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                  Divider(color:Colors.black,thickness: 0.1),
                  ListTile(
                    leading:Icon(Icons.email),
                    title:Text("만든이"),
                    onTap :  () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs())),
                  ),
                  Divider(color:Colors.black,thickness: 0.1,),
                  ListTile(
                    leading:Icon(Icons.logout),
                    title:Text("로그아웃"),
                    onTap :  () => showDialog(
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
        ],
      ),
    );
  }
  _buildBody() {
    return GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus();
    },
    child:Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // sliver app bar
            homeheader(),
            //중간에 부분..
            Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(icon: Icon(Icons.cloud), onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherPage(Data: weatherData)));
                  }),
                  FutureBuilder(
                    future: getData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(!snapshot.hasData) return CircularProgressIndicator();
                      return Container(
                        child: Row(
                          children: [

                            Text("${snapshot.data['name']}  "
                            ),
                            Text("${snapshot.data['main']['temp'].toStringAsFixed(0)} °C",
                              style: TextStyle(fontSize: 20,color: Colors.black, fontWeight: FontWeight.bold),
                            ),



                          ],
                        ),
                      );
                    },
                  ),
                  Spacer(),
                  gps == true
                      ? IconButton(
                        icon: Icon(Icons.gps_fixed),
                        onPressed: (){
                          scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("위치정보를 정상적으로 받아오는중입니다.")));
                      },
                  )
                      :IconButton(
                         icon: Icon(Icons.gps_not_fixed),
                         onPressed: (){
                            scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("위치정보를 받는중 에러가 발생하였습니다.")));
                    },
                  ),
                  //Text('show more', style: TextStyle(color: Colors.cyan),),
                ],
              ),
            ),


            // 여기에 아이콘 리스트들 쭈르륵 나올 수 있도록
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 20, left: 40, right: 40),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Maps()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.map_outlined, size: 55,),
                        ),
                        Padding(padding: EdgeInsets.all(5),),
                        Text('지도'), // 서브메뉴 1
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SmallTalk()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.notifications_active_outlined, size: 50,),
                        ),
                        Padding(padding: EdgeInsets.all(5),),
                        Text('공지사항'), // 서브메뉴 2
                      ],
                    ),
                  ),                  GestureDetector(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SmallTalk()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Icon(Icons.chat_outlined, size: 47,),
                        ),
                        Padding(padding: EdgeInsets.all(5),),
                        Text('산타의 한마디'), // 서브메뉴 3
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            //
            // Container(
            //   margin: EdgeInsets.only(left: 30, right: 30, top: 10 ,bottom :10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       //color: Colors.
            //       Text('산타의 추천', style: TextStyle(fontSize:15, fontWeight:FontWeight.w700,letterSpacing:0.22)),
            //       Text('show more', style: TextStyle(color: Colors.cyan),),
            //     ],
            //   ),

            Container(
              margin: EdgeInsets.only(left: 30, right: 20, top: 0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //color: Colors.
                  Text('산타의 한마디', style: TextStyle(fontSize:15, fontWeight:FontWeight.w700,letterSpacing:0.22,color: Colors.cyan)),
                  IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.cyan, size: 18,),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SmallTalk()));
                      },
                  ),

                ],
              ),

            ),



            Padding(padding: EdgeInsets.only(top: 5)),
            Text('오늘 하루는 저처럼 퇴사가 마려운 하루인가여?'),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Divider(),
            Container(
              margin: EdgeInsets.only(left: 30, right: 20, top: 0),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //color: Colors.
                  Text('HOT 게시글', style: TextStyle(fontSize:15, fontWeight:FontWeight.w700,letterSpacing:0.22,color: Colors.cyan)),
                  IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.cyan, size: 18,),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SmallTalk()));
                    },
                  ),

                ],
              ),

            ),

            Padding(padding: EdgeInsets.only(top: 5)),
            Text('나는야 퉁퉁이'),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Padding(padding: EdgeInsets.only(top: 5)),
            Text('멋쟁이 토마토'),
            Padding(padding: EdgeInsets.only(bottom: 10)),
            Divider(),
          ],
        ),
      ),

    ),
    );
  }

  Widget homeheader() {
    return Stack(
      children: <Widget>[

        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.9,
          child: ClipPath(
            child: Image.asset('images/Design.jpeg' ,fit: BoxFit.fill,),
          ),
        ),
        // Opacity(
        //   opacity: 0.75,
        //   child: ClipPath(
        //     child: Image.asset('images/santalogo.png'),
        //   ),
        // ),

        //검색창
        Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: MediaQuery.of(context).size.height / 3.2),
          child: Material(
            borderRadius: BorderRadius.circular(32.0),
            elevation: 8,
            child: Container(

              child: TextFormField(
                focusNode: myFocusNode,
                cursorColor: Colors.cyan,
                keyboardType: TextInputType.text,
                controller: mycontroller,
                onEditingComplete: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo(mycontroller.text)));
                },

                decoration: InputDecoration(

                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: GestureDetector(
                    child: Icon(Icons.search, color: Colors.cyan, size: 30,),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo(mycontroller.text)));
                    },
                  ),
                  hintText: "가고싶은 산을 검색하세요",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide.none
                  ),
                ),
              ),
            ),
          ),
        ),

       // Drawer 부분!!!
        RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                children: [
                  IconButton(icon: Icon(Icons.menu),
                      onPressed: (){
                        scaffoldKey.currentState.openDrawer();
                  }),

                ],
              ),
            ),
          ),
        ),

      ],
    );

  }

}
