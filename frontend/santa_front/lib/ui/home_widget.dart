import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:santa_front/ui/maps_widget.dart';
import 'package:santa_front/ui/weather_widget.dart';
import 'mountain_info.dart';
import 'package:santa_front/navigation/aboutus.dart';
import 'package:santa_front/ui/smalltalk_widget.dart';
import 'package:http/http.dart' as http;
import 'package:santa_front/ui/login_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeWidget extends StatefulWidget {
  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final mycontroller = TextEditingController();
  FocusNode myFocusNode;

  bool gps;
  var weatherData;



  String weatherUrl = 'http://api.openweathermap.org/data/2.5/weather?';
  String lat = '';
  String lon = '';
  String appId = 'appid=8cdd068d54bf1713cb88cb026decbf95&';
  String units = 'units=metric';

  String provider = 'None';
  String name = 'None';
  String photo = 'None';
  String email = 'None';

  SharedPreferences _prefs;

  Future<bool> user() async {
    _prefs ??= await SharedPreferences.getInstance();
    provider = (_prefs.getString('Provider') ?? '');
    name = (_prefs.getString('Name') ?? '');
    photo = (_prefs.getString('Photo') ?? '');
    email = (_prefs.getString('Email') ?? '');
  }

  _drawerInfo(){
    var _currentImg = photo;
    var _currentId = name;
    var _currentEmail = email;

    if(_currentImg == "None"){
      return CircularProgressIndicator();
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

  // ???????????? ??????
  LogOut(){
    Navigator.of(context, rootNavigator: true).pop('dialog');  //??????
    if (provider == 'kakao') {
      LogOutUser(); // ????????? ????????????
    }else if(provider == 'google'){
      final GoogleSignIn _googleSignIn = new GoogleSignIn();
      _googleSignIn.signOut();
      _prefs.clear(); // SharedPrefer ?????? ?????? ??? ??? !
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginWidget(),), (route) => false, ); //??????????????? ?????????
    }else{
      print("????????????");
    }
  }

//????????? ?????? ?????? ????????????
//   Future _KakaoUser() async {
//     try {
//       User user = await UserApi.instance.me(); // ????????????
//       //  print(user.toString());
//       setState(() {
//         provider = 'Kakao';
//         _accountEmail = user.kakaoAccount.email;
//         _ageRange = user.kakaoAccount.ageRange.toString();
//         _gender = user.kakaoAccount.gender.toString();
//         _nickname =user.kakaoAccount.profile.nickname;
//         _profile = user.kakaoAccount.profile.profileImageUrl.toString();
//         _userId = user.id.toString(); //???????????????
//
//       });
//
//     } catch (e) {
//       print("Error With KakaoUserInfo");
//     }
//   }

  void permission()async{ // ???????????? ?????? < ?????? >
    await requestPermission();
    var value = await checkPermission();
    setState(() {
      if(value == LocationPermission.always || value == LocationPermission.whileInUse){
        gps = true;
        print("Geo value Success");
      }else{
        gps = false;
        print(value); // ????????? ??????
      }
    });
  }

  LogOutUser() async {   // ???????????? ??????
    if(name != 'None'){
      try {
        var code = await UserApi.instance.logout();
        print(code.toString());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginWidget(),), (route) => false, ); //??????????????? ?????????
      } catch (e) {
        print("???????????? ?????? : $e");
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
      Uri.encodeFull(weatherUrl+lat+lon+appId+units),
      headers:  {"Accept" : "application/json"},

    );
    //print(url+lat+lon+appId+units);
   // print("ResponseBody : ${response.body}");
    weatherData = jsonDecode(response.body);
 //   print(weatherData);
    // if(weatherData['main']['temp']< 15){
    //   print('??????');
    // }else{
    //   print("??????");
    // }

    return weatherData;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permission(); // ?????????
    user(); // ???????????????
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
      onWillPop: () {
        return;
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer : _drawer(),

        //appBar: buildAppBar(),
        body: _buildBody(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo())); // ????????????????????? ??????
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
      title: Text('HomeWidget'),
    );
  }
*/
  _drawer(){
    FocusScope.of(context).requestFocus(new FocusNode()); // ????????? ??????
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
                  title:Text("??????"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                Divider(color:Colors.black,thickness: 0.1),
                ListTile(
                  leading:Icon(Icons.email),
                  title:Text("?????????"),
                  onTap :  () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUs())),
                ),
                Divider(color:Colors.black,thickness: 0.1,),
                ListTile(
                  leading:Icon(Icons.logout),
                  title:Text("????????????"),
                  onTap :  () => showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('???????????? ???????????????????'),
                          actions: [
                            FlatButton(
                              onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),  //??????
                              child: Text('??????'),
                            ),
                            FlatButton(
                              onPressed: () => LogOut(), // passing true
                              child: Text('????????????'),
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
              //????????? ??????..
              Container(
                margin: EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.cloud), onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherWidget(data: weatherData)));
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
                              Text("${snapshot.data['main']['temp'].toStringAsFixed(0)} ??C",
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
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("??????????????? ??????????????? ????????????????????????.")));
                      },
                    )
                        :IconButton(
                      icon: Icon(Icons.gps_not_fixed),
                      onPressed: (){
                        scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("??????????????? ????????? ????????? ?????????????????????.")));
                      },
                    ),
                    //Text('show more', style: TextStyle(color: Colors.cyan),),
                  ],
                ),
              ),


              // ????????? ????????? ???????????? ????????? ?????? ??? ?????????
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20, left: 40, right: 40),
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MapsWidget()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.map_outlined, size: 55,),
                          ),
                          Padding(padding: EdgeInsets.all(5),),
                          Text('??????'), // ???????????? 1
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SmallTalkWidget()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.notifications_active_outlined, size: 50,),
                          ),
                          Padding(padding: EdgeInsets.all(5),),
                          Text('????????????'), // ???????????? 2
                        ],
                      ),
                    ),                  GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SmallTalkWidget()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.chat_outlined, size: 47,),
                          ),
                          Padding(padding: EdgeInsets.all(5),),
                          Text('????????? ?????????'), // ???????????? 3
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
              //       Text('????????? ??????', style: TextStyle(fontSize:15, fontWeight:FontWeight.w700,letterSpacing:0.22)),
              //       Text('show more', style: TextStyle(color: Colors.cyan),),
              //     ],
              //   ),

              Container(
                margin: EdgeInsets.only(left: 30, right: 20, top: 0),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //color: Colors.
                    Text('????????? ?????????', style: TextStyle(fontSize:15, fontWeight:FontWeight.w700,letterSpacing:0.22,color: Colors.cyan)),
                    IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.cyan, size: 18,),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SmallTalkWidget()));
                      },
                    ),

                  ],
                ),

              ),



              Padding(padding: EdgeInsets.only(top: 5)),
              Text('?????? ????????? ????????? ????????? ????????? ????????????????'),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Divider(),
              Container(
                margin: EdgeInsets.only(left: 30, right: 20, top: 0),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //color: Colors.
                    Text('HOT ?????????', style: TextStyle(fontSize:15, fontWeight:FontWeight.w700,letterSpacing:0.22,color: Colors.cyan)),
                    IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.cyan, size: 18,),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SmallTalkWidget()));
                      },
                    ),

                  ],
                ),

              ),

              Padding(padding: EdgeInsets.only(top: 5)),
              Text('????????? ?????????'),
              Padding(padding: EdgeInsets.only(bottom: 10)),
              Padding(padding: EdgeInsets.only(top: 5)),
              Text('????????? ?????????'),
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

        //?????????
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfoWidget(mycontroller.text)));
                },

                decoration: InputDecoration(

                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: GestureDetector(
                    child: Icon(Icons.search, color: Colors.cyan, size: 30,),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfoWidget(mycontroller.text)));
                    },
                  ),
                  hintText: "???????????? ?????? ???????????????",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide.none
                  ),
                ),
              ),
            ),
          ),
        ),

        // Drawer ??????!!!
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
