import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class BoardDetail extends StatefulWidget {
  @override
  _BoardDetailState createState() => _BoardDetailState();
}

class _BoardDetailState extends State<BoardDetail> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); // 방향전환 세로고정
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: 15)),
          Row(
            children: [

              Padding(padding: EdgeInsets.only(left: 15)),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                        image: AssetImage('images/santalogo.png'),
                        fit: BoxFit.cover),
                    borderRadius:
                    BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 3.0, color: Colors.black)
                    ]),
              ),
              Container(
                padding: EdgeInsets.only(top: 10 ,left:10),
                child: Column(
                  children: [
                    Text('산타'),
                    Text('5분전',style: TextStyle(color: Colors.grey),),
                  ],
                ),

              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 10),
            width: 420,
            height: 300,
            child: Image.asset('images/santalogo.png',fit: BoxFit.cover,),
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left:10,top: 10)),

              Icon(Icons.favorite_border,color: Colors.black, size: 24 ,),
              Padding(padding: EdgeInsets.only(left:5)),
              Icon(Icons.comment_bank_outlined,color: Colors.black, size: 24 ,),
              Padding(padding: EdgeInsets.only(left:5)),
              Icon(Icons.share_outlined,color: Colors.black, size: 24 ,),

            ],
          ),
          Padding(padding: EdgeInsets.only(top: 10)),

          Row(
            children: [

              Padding(padding: EdgeInsets.only(left:10,top: 10)),
              Text(" 산타",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
              Text("  아찔한 진자운동을 하였다.",style: TextStyle(fontSize: 15),),

            ],
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Divider(),
          Padding(padding: EdgeInsets.only(top: 10)),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left:10,top:4)),
              Text("Liked * Times",style: TextStyle(fontSize: 12),),
            ],
          ),

          //COMMENT
          Container(
            child:Column(
              children: [

                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left:10,top: 25)),
                    Text(" 좀타",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    Text("  정말 아찔하네요....!",style: TextStyle(fontSize: 15),),
                  ],
                ),


                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left:10,top: 25)),
                    Text(" 기타",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    Text("  진자운동이라니 .....!",style: TextStyle(fontSize: 15),),
                  ],
                ),

                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left:10,top: 25)),
                    Text(" 혼다",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                    Text("  키미노 나마에와....?!",style: TextStyle(fontSize: 15),),
                  ],
                ),
              ],
            ),

          ),
        ],
      ),


    );
  }
}
