import 'package:flutter/material.dart';

class BoardList extends StatefulWidget {
  @override
  _BoardListState createState() => _BoardListState();
}






class _BoardListState extends State<BoardList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildBody(),
    );
  }


}
Widget _buildBody() {
//  if (게시판 글 수 .length != 0) {
    return ListView.builder(

      padding: const EdgeInsets.only(top: 80,left: 16, right: 16),
      itemBuilder: board_list,
      itemCount: 10,
    );
  }

Widget board_list(BuildContext context, int index) {
  return Container(
    height: 430,
    child: Card(
//                color: Colors.blue,
      elevation: 10,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 14, left: 10),
                child: GestureDetector(
                  onTap: () {

                  },
                  child: Container(
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
                ),
              ),
              GestureDetector(
                onTap: () {
                  //눌렀을시 넘어갈 다음화면
                },
                child: Container(
                  padding: EdgeInsets.only(top: 15 ,left:10),
                  child: Column(
                    children: [
                      Text('산타'),
                      Text('5분전',style: TextStyle(color: Colors.grey),),
                    ],
                  ),

                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20,bottom: 10),
            width: 420,
            height: 300,
            child: Image.asset('images/santalogo.png',fit: BoxFit.cover,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(" 산타",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
              Text("  아찔한 진자운동을 하였다.",style: TextStyle(fontSize: 15),),

            ],
          ),
          Text(''),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Icon(Icons.favorite_border,color: Colors.black, size: 20 ,),

              Text("  ",style: TextStyle(fontSize: 15),),
            ],
          ),

        ],
      ),



    ),
  );
}