import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'mountain_detail.dart';
import 'dart:async';
import '../alert.dart';
import 'package:santa_front/model/mountain.dart';
import 'package:santa_front/pk_skeleton.dart';


//
//
// Todo = _buildBody에서 타임아웃 설정해야함 ELSE부분.. 무한로딩중 완료
//
//


class MountainInfoWidget extends StatefulWidget {
  final String mtWord;
  MountainInfoWidget(this.mtWord);


  @override
  _MountainInfoWidgetState createState() => _MountainInfoWidgetState();
}

class _MountainInfoWidgetState extends State<MountainInfoWidget> {
  var mtData;
  var decodeData;
  var deepInfo;


  //
  // var img_data;
  // var decode_img_data;
  // var img_deepInfo;

  Mountain mt;
  List<Mountain> searchMt = [];

  //http://apis.data.go.kr/1400000/service/cultureInfoService/mntInfoImgOpenAPI?
  // mntiListNo=111100101&
  // ServiceKey=pnpnaretHrGHzfUsPt1RVDcThKijR7FalZPJqZUcdWH1hN3CX0W%2Fq%2F%2FknP%2FFY5b5PlrkxRqfsJjSjzlUdj%2Fj7g%3D%3D

  final String mtKey = 'pnpnaretHrGHzfUsPt1RVDcThKijR7FalZPJqZUcdWH1hN3CX0W/q//knP/FY5b5PlrkxRqfsJjSjzlUdj/j7g==';
  String url = 'http://apis.data.go.kr/1400000/service/cultureInfoService/';
  String serviceId = 'mntInfoOpenAPI?serviceKey=';


  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getMData();
  }


  Future getMData() async {
    //산정보
    http.Response response = await http.get(
      Uri.encodeFull(url + serviceId + mtKey +'&searchWrd='+ widget.mtWord ),
      headers: {"Accept": "application/json"},

    );
    mtData = utf8.decode(response.bodyBytes);
    decodeData = jsonDecode(mtData);

    try {
      deepInfo = decodeData['response']['body']['items']['item'];
    } catch(e){
      return _alertError();
    }
    //print(deepInfo);

    if (!(deepInfo is List)) {
      Mountain mt1 = Mountain(
          mntiname: deepInfo['mntiname'],
          mntilistno: deepInfo['mntilistno'].toString(),
          mntihigh: deepInfo['mntihigh'].toString(),
          mntidetails: deepInfo['mntidetails'],
          mntiadminnum: deepInfo['mntiadminnum'],
          mntiadmin: deepInfo['mntiadmin'],
          mntiadd: deepInfo['mntiadd']
      );
      print('검색 결과 : ${mt1.mntilistno}');
      setState(() {
        searchMt.add(mt1);
      });
    }
    else {
      for (int i = 0; i < deepInfo.length; i++) {
        Mountain mt1 = Mountain(
            mntiname: deepInfo[i]['mntiname'],
            mntilistno: deepInfo[i]['mntilistno'].toString(),
            mntihigh: deepInfo[i]['mntihigh'].toString(),
            mntidetails: deepInfo[i]['mntidetails'],
            mntiadminnum: deepInfo[i]['mntiadminnum'],
            mntiadmin: deepInfo[i]['mntiadmin'],
            mntiadd: deepInfo[i]['mntiadd']
        );
//${widget.searchWrd}
        print('${widget.mtWord} 검색 결과 : ${mt1.mntilistno}');
        setState(() {
          searchMt.add(mt1);
        });
      }
    }



    return deepInfo;
  }


 void _alertError(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => AlertPage()));
 }
  //
  // Scaffold(
  // floatingActionButton: FloatingActionButton(
  // onPressed: (){
  //
  // getMData();
  // },
  // child: Icon(Icons.add, color: Colors.white,),
  // backgroundColor: Colors.black,
  // ),
  // appBar: AppBar(
  //
  // title: Text('aa'),
  // ),
  // // body: FutureBuilder(
  // //   future: getMData(),
  // //   builder: (BuildContext context, AsyncSnapshot snapshot){
  // //     if(!snapshot.hasData) return CircularProgressIndicator();
  // //     return Container(
  // //       child: Row(
  // //         children: [
  // //           Text("${snapshot.data['response']['body']['items']['item']}",
  // //           ),
  // //
  // //
  // //         ],
  // //       ),
  // //     );
  // //   },
  // // ),
  // );
  //    //산 이미지정보
  //     http.Response responseImg = await http.get(
  //       Uri.encodeFull(url + imgServiceId + mtKey +'&searchWrd='+ widget.mtWord ),
  //       headers: {"Accept": "application/json"},
  //
  //     );
  //     mt_img = utf8.decode(responseImg.bodyBytes);
  //     decode_img = jsonDecode(mt_img);
  //     print('image  ='+ decode_img);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return Scaffold(
      appBar: AppBar(title: Text('${widget.mtWord} 검색 결과'),),
      body: _buildBody(),
//      endDrawer: DrawerPage(),
      //resizeToAvoidBottomInset: false,
    );
  }



  Widget _buildBody() {
    if (searchMt.length != 0) {
      return ListView.builder(
        itemBuilder: searchedData,
        itemCount: searchMt.length,
      );
    }
    else { // 검색결과 null
      return Container(
        child: PKCardListSkeleton(
          isCircularImage: true,
          isBottomLinesActive: true,
          length: 10,
        ),

      );
    }
  }



  Widget searchedData(BuildContext context, int index) {
    return Container(
        margin: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 9),
        //height: MediaQuery.of(context).size.height / 3.5,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: Offset(4, 4),
                  blurRadius: 16
              )
            ]
        ),
        child: GestureDetector(
          onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainDetailWidget(searchMt[index])));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2,
                      child: Image.network(
                        'https://youimg1.tripcdn.com/target/100m1f000001gzon8658E_C_750_500.jpg?proc=source%2Ftrip',
                        fit: BoxFit.cover,),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        searchMt[index].mntiname,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Colors.black87.withOpacity(
                                                0.9)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 0,
                                          right: 16,
                                          top: 6,
                                          bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Icon(Icons.place, size: 18,
                                            color: Colors.cyan,),
                                          Padding(
                                            padding: EdgeInsets.all(2),),
                                          Expanded(
                                            child: Text(
                                              searchMt[index].mntiadd,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                          Icon(
                                            Icons.favorite_border, size: 18,
                                            color: Colors.cyan,)
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                            ),
                          ),
                          /*
                        Padding(
                          padding: EdgeInsets.only(right: 16,top: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text('뭐가 들어갈지 모르겟군뇨'),
                            ],
                          ),
                        ),
    */
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}