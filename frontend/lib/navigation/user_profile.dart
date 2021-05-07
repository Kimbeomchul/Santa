import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}



class _UserProfileState extends State<UserProfile> {

  Widget stats(String statName, int statCount) { // 팔로우 포스트 팔로일 
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 5)),
        Text(
          statCount.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        Padding(padding: EdgeInsets.only(top: 5)),
        Text(statName),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
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
                Padding(padding: EdgeInsets.only(left: 5),
                child : Row(
                  children: [
                    Container(
                      width:100,
                      height:100,
                      decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[500],
                          offset: Offset(4.0, 4.0),
                          blurRadius: 15.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                        shape:  BoxShape.circle,
                        image: DecorationImage(

                          fit:BoxFit.fill,
                          image : AssetImage('images/santalogo.png'),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: 40)),
                                  stats('게시물', 20),
                                  Padding(padding: EdgeInsets.only(left: 35)),
                                  stats('팔로워', 111),
                                  Padding(padding: EdgeInsets.only(left: 35)),
                                  stats('팔로잉', 203),
                                ],
                              ),

                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Padding(padding: EdgeInsets.only(top:20,left: 50)), // 사진과 이외의 거리
                        //     Text('게시글'),
                        //     Padding(padding: EdgeInsets.only(left: 30)), // 사진과 이외의 거리
                        //     Text('팔로우'),
                        //     Padding(padding: EdgeInsets.only(left: 30)), // 사진과 이외의 거리
                        //     Text('좋아요'),
                        //   ],
                        // ),

                      ],
                    ),

                  ],
                ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(color:Colors.black),
              ],
            ),

          ),

        ],

      ),
    );
  }

}