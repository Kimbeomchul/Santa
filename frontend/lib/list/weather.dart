import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:santa_front/list/HomePage.dart';

class WeatherPage extends StatefulWidget {
  final Data; // 날씨데이터
  WeatherPage({Key key, @required this.Data}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  DateFormat formatter = DateFormat('H시 m분 s초');
  DateFormat sun = DateFormat('H시 m분');
  var textground = Color(0xFFB1D1CF);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return Scaffold(

      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/맑음_범철.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child:
                  IconButton(
                      icon:
                      Icon(
                        Icons.arrow_back,
                        color: Colors.black54,
                      ),
                      onPressed: (){
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
            Text('${widget.Data['weather'][0]['main']}',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 16,
                ),
                Text(' ${widget.Data['name']}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.Data['main']['temp'].toStringAsFixed(0)}',
                  style: TextStyle(
                      fontSize: 65,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Text(
                      '°C',
                      style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                   ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       '최고 ',
                    //       style: TextStyle(
                    //           fontSize: 11,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //     Text(
                    //       '${widget.Data['main']['temp_max'].toStringAsFixed(0)}°C',
                    //       style: TextStyle(
                    //           fontSize: 15,
                    //           color: Colors.white,
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Text(
                          '체 ',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.Data['main']['feels_like'].toStringAsFixed(0)}°C',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Container(
              height: 320,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Divider(color: Colors.white,thickness: 0.5,),

                  Container(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.cloud,
                                  color: Colors.white,
                                ),
                                Column(
                                children:[
                                  Text('시안성',style: TextStyle(color: Colors.white,fontSize: 14),),
                                  Text('  ${widget.Data['clouds']['all']} %',style: TextStyle(color: Colors.white,fontSize: 16),),

                                ],
                                ),
                                  VerticalDivider(
                                  color: Colors.white,
                                ),
                                Icon(
                                      Icons.cloud_circle,
                                      color: Colors.white,
                                    ),

                                Column(
                                  children:[
                                    Text('풍속',style: TextStyle(color: Colors.white,fontSize: 14),),
                                    Text('${widget.Data['wind']['speed']} m/s',style: TextStyle(color: Colors.white,fontSize: 16),),

                                  ],
                                ),
                              ],
                            )),

                        SizedBox(
                          height: 20,
                        ),
                        IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.grain,
                                  color: Colors.white,
                                ),
                                Column(
                                  children:[
                                    Text('습도',style: TextStyle(color: Colors.white,fontSize: 14),),
                                    Text('  ${widget.Data['main']['humidity']} %',style: TextStyle(color: Colors.white,fontSize: 16),),

                                  ],
                                ),
                                VerticalDivider(
                                  color: Colors.white,
                                ),
                                Icon(
                                  Icons.cloud_circle,
                                  color: Colors.white,
                                ),

                                Column(
                                  children:[
                                    Text('뭘까이건',style: TextStyle(color: Colors.white,fontSize: 14),),
                                    Text('${widget.Data['visibility']} ',style: TextStyle(color: Colors.white,fontSize: 16),),

                                  ],
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                infoSpace(
                                    Icons.wb_sunny,
                                    '일출',
                                    sun.format(DateTime.fromMillisecondsSinceEpoch(
                                        widget.Data['sys']['sunrise'] * 1000))),
                                VerticalDivider(
                                  color: Colors.white,
                                ),
                                infoSpace(
                                    Icons.nights_stay,
                                    '일몰',
                                    sun.format(DateTime.fromMillisecondsSinceEpoch(
                                        widget.Data['sys']['sunset'] * 1000))),
                              ],
                            )),
                      ],
                    ),
                  ),

                  Divider(color: Colors.white,thickness: 0.5,),

                  Container(
                      padding: EdgeInsets.only(right: 10, top: 10),
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Last Update: ${formatter.format(DateTime.now())}',style: TextStyle(fontSize: 13,color: Colors.white),),

                          Padding(padding: EdgeInsets.only(top: 10)),
                          GestureDetector(
                            onTap :  () => showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text('날씨 도움말',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                    content: Text('* 강수량은 최근 1시간의 강수량을 측정합니다.\n* 체감온도는 현시각의 체감온도를 나타냅니다.\n* 풍속\n4m/s미만 약한바람\n4~9m/s 약간강한바람\n9~14m/s 강한바람\n14m/s이상은 매우강한바람\n9m/s가 초과할 시 등산은 추천드리지 않습니다.'
                                    ,style: TextStyle(fontSize: 17),),
                                    actions: [
                                      FlatButton(
                                        onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),  //취소
                                        child: Text('닫기'),
                                      ),
                                    ],
                                  );
                                }),  // 설명서
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                Text('도움말',style: TextStyle(fontSize: 13,color: Colors.white),),
                                Icon(
                                  Icons.campaign_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ],
                            ),

                          ),


                        ],
                      ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoSpace(IconData icons, String topText, String bottomText) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icons,
            color: Colors.white,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5,
            child: Column(
              children: [Text(topText,style: TextStyle(color: Colors.white,fontSize: 16),), Text(bottomText,style: TextStyle(color: Colors.white,fontSize: 16),)],
            ),
          )
        ],
      ),
    );
  }
}
