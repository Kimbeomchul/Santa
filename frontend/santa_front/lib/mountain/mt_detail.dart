import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'mountain_model.dart';
import 'package:expandable/expandable.dart';


class MtDetailPage extends StatefulWidget {
  final Mountain mountain;
 // final String imglink;
  MtDetailPage(this.mountain);

  @override
  _MtDetailPageState createState() => _MtDetailPageState();
}

class _MtDetailPageState extends State<MtDetailPage>
    with TickerProviderStateMixin {
  //이제 여기에 그.. 정보들을 띄워주면 된다능. 어렵지 않다능~~~!!~!~!~!
  final String clientKey = 'ntqx0%2BT6eKi2wLBQvSktuws5aGsQIdWFnih93w9ksArXbyHrzGWtBvuxw58F4FHTywBjVl4e5H7zj1dfHeVQJA%3D%3D';
  final String searchUrl1= 'http://apis.data.go.kr/1400000/service/cultureInfoService/mntInfoImgOpenAPI?mntiListNo=';
  final String searchUrl2 = '&ServiceKey=';
  final String searchUrl3 = '&_type=json';

  List<String> searchImagelist = [];

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn));
    setData();
    super.initState();
  }

  void setData() async{
    animationController.forward();
  }

Widget detailIf(){
    var detailInfo = widget.mountain.mntidetails.toString();

    if(detailInfo == "( - )"){
      detailInfo ='산 정보기 존재하지 않습니다. 빠르게 추가하도록 하겠습니다!';
    }else{
      detailInfo = widget.mountain.mntidetails;
    }
    return ExpandablePanel(

      header: Text('상세 설명', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.27, color: Colors.cyan), ),
      expanded: Text(detailInfo, softWrap: true, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black54),),
      tapHeaderToExpand: true,
      hasIcon: true,
      collapsed: Text(detailInfo, softWrap: true, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, letterSpacing: 0.27, color: Colors.black54),),
    );
}
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    final tempHight = (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width / 1.2) + 24.0);

    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 250.0,
          pinned: false,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            //title: Text(widget.mountain.mntiname, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
            background: Image.network('https://youimg1.tripcdn.com/target/100m1f000001gzon8658E_C_750_500.jpg?proc=source%2Ftrip', fit: BoxFit.cover,),

          ),

        ),
        SliverFillRemaining(
          child: Container(
            color: Colors.white,
            child: Column(

              textDirection: TextDirection.ltr,
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: GestureDetector(
                        child: Icon(Icons.favorite,color: Colors.blue, ),
                      ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 15),
                  child: Text(widget.mountain.mntiname, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 30, letterSpacing: 0.27), textAlign: TextAlign.left,),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('주소', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyan),),
                      Text(widget.mountain.mntiadd, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('전화번호', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyan),),
                      Text(widget.mountain.mntiadminnum, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('높이', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.cyan),),
                      Text(widget.mountain.mntihigh + 'm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15),
                  child: Column(
                    children: <Widget>[
                      detailIf(), // 산 디테일정보 분기
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}