import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:santa_front/list/weather.dart';
import 'package:santa_front/mountain/mt_info.dart';
import 'package:santa_front/navigation/board_list.dart';
import 'package:santa_front/main.dart';
import 'package:santa_front/list/santa_recommand.dart';
import 'package:santa_front/list/santa_smalltalk.dart';
import 'package:http/http.dart' as http;
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final mycontroller = TextEditingController();

  bool gps;

  var weatherData;

  String url = 'http://api.openweathermap.org/data/2.5/weather?';
  String lat = '';
  String lon = '';
  String appId = 'appid=8cdd068d54bf1713cb88cb026decbf95&';
  String units = 'units=metric';




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
  // _title(){
  //   return 'Lorem Ipsum Title';
  // }

  Future<Null> _onRefresh()async{ // Drawer
    setState(() {

    });
  }

  Future getData()async{
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    lat = "lat=" + position.latitude.toString() + '&';
    lon = "lon=" + position.longitude.toString() + '&';

    http.Response response = await http.get(
      Uri.encodeFull(url+lat+lon+appId+units),
      headers:  {"Accept" : "application/json"},

    );
    print("ResponseBody : ${response.body}");
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
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return GestureDetector( // 드로어 열시 키보드 포커스제거
        onTap: () {
      FocusScope.of(context).unfocus();
          },
      child: Drawer(
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
                  Container(
                    width:50,
                    height:50,
                    decoration: BoxDecoration(
                      shape:  BoxShape.circle,
                      image: DecorationImage(
                          fit:BoxFit.fill,
                          image : AssetImage('images/santalogo.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                   height: 10,
                  ),
                  Text('ID가 들어갈자리 , ex) Santa',
                  style: TextStyle(
                    fontSize: 16,
                    color:Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                  Text("이메일이 들어갈자리 , ex) abc@abc.com ",style: TextStyle(
                    color: Colors.black
                  ),),
                Divider(color:Colors.black),
                  ListTile(
                    leading:Icon(Icons.settings),
                    title:Text("settings"),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),

                ],
              ),

          ),
        ],
      ),
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
              padding: EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SantaRec()));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Image.asset('images/favo.png', fit: BoxFit.cover),
                          width: 60, height: 60,
                        ),
                        Padding(padding: EdgeInsets.all(5),),
                        Text('산타의 추천'), // 서브메뉴 1
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
                            child: Image.asset('images/noti.png', fit: BoxFit.cover),
                          width: 60, height: 60,
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
                          child: Image.asset('images/talk.png', fit: BoxFit.cover),
                          width: 60, height: 60,
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
        //헤더? 같은 부분. sliver appbar 로 구현을 해야할 것 같긴 하나.. 어떻게 하지~~

        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.9,
          child: ClipPath(
            child: Image.asset('images/logo.jpeg' ,fit: BoxFit.fill,),
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
                //여기에 클릭을 하면 검색이 되도록!!! 할 수 있어야 한다능~
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
