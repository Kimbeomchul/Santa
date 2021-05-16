import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../FadeAnimation.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 450,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/Design.jpeg'),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(.3)
                              ]
                          )
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FadeAnimation(1, Text("Santa", style:
                            TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40)
                              ,)),
                            SizedBox(height: 20,),
                            Row(
                              children: <Widget>[
                                FadeAnimation(1.2,
                                    Text("등산 정보제공/공유 커뮤니티", style: TextStyle(color: Colors.grey, fontSize: 16),)
                                ),
                                SizedBox(width: 50,),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(1.6, Text("산타는 등산에 관한 정보제공 및 공유를 하는 커뮤니티 형식의 애플리케이션입니다. 원하시는 기능이나 정보를 아래에 있는 개발자에게 전달해 주시면 빠르게 적용하도록 하겠습니다.",
                          style: TextStyle(color: Colors.grey, height: 1.4),)),
                        SizedBox(height: 40,),
                        FadeAnimation(1.6,
                            Text("Update", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                        ),
                        SizedBox(height: 10,),
                        FadeAnimation(1.6,
                            Text("May, 15th 2021,  Version 0.01", style: TextStyle(color: Colors.grey),)
                        ),
                        SizedBox(height: 20,),
                        FadeAnimation(1.6,
                            Text("Developer", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                        ),
                        SizedBox(height: 4,),
                        Row(
                          children: [
                            FadeAnimation(1.6,
                                Text("김범철 ", style: TextStyle(color: Colors.grey,fontSize: 14),)
                            ),
                            FadeAnimation(1.6,
                                IconButton(
                                  // Use the MdiIcons class for the IconData
                                    icon: new Icon(MdiIcons.instagram,color: Colors.grey,),
                                    onPressed: () {
                                      launch('https://www.instagram.com/m_ozz_i/', forceWebView: true, forceSafariVC: true); //범철 인스타
                                    }
                                ),
                            ),
                            FadeAnimation(1.6,
                              IconButton(
                                // Use the MdiIcons class for the IconData
                                  icon: new Icon(MdiIcons.github,color: Colors.grey,),
                                  onPressed: () {
                                    launch('https://github.com/Kimbeomchul', forceWebView: true, forceSafariVC: true);//범철 깃허브이동
                                  }
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            FadeAnimation(1.6,
                                Text("윤준기 ", style: TextStyle(color: Colors.grey,fontSize: 14),)
                            ),
                            FadeAnimation(1.6,
                              IconButton(
                                // Use the MdiIcons class for the IconData
                                  icon: new Icon(MdiIcons.instagram,color: Colors.grey,),
                                  onPressed: () {
                                    launch('https://www.instagram.com/leffe_pt/', forceWebView: true, forceSafariVC: true); //준기 인스타
                                  }
                              ),
                            ),
                            FadeAnimation(1.6,
                              IconButton(
                                // Use the MdiIcons class for the IconData
                                  icon: new Icon(MdiIcons.github,color: Colors.grey,),
                                  onPressed: () {
                                    launch('https://github.com/na86421', forceWebView: true, forceSafariVC: true);//준기  깃허브이동
                                  }
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        FadeAnimation(1.6,
                            Text("Used", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)
                        ),
                        SizedBox(height: 10,),
                        FadeAnimation(1.6,
                            Text("Frontend : Flutter", style: TextStyle(color: Colors.grey),)
                        ),
                        FadeAnimation(1.6,
                            Text("Backend : Django", style: TextStyle(color: Colors.grey),)
                        ),
                        FadeAnimation(1.6,
                            Text("Database : Postgre", style: TextStyle(color: Colors.grey),)
                        ),
                        FadeAnimation(1.6,
                            Text("Server : Google Cloud Platform", style: TextStyle(color: Colors.grey),)
                        ),
                        FadeAnimation(1.6,
                            Text("Version : Github", style: TextStyle(color: Colors.grey),)
                        ),
                        FadeAnimation(1.6,
                            Text("Chat : Notion / Slack", style: TextStyle(color: Colors.grey),)
                        ),
                        FadeAnimation(1.6,
                            Text("Others : Docker , Jenkins , Jira", style: TextStyle(color: Colors.grey),)
                        ),
                        SizedBox(height: 120,)
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
          Positioned.fill(
            bottom: 50,
            child: Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FadeAnimation(2,
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.cyan[600]
                    ),
                    child:
                    Align(
                        child: GestureDetector(
                          onTap: () => {
                            // 결제시스템 구현하기
                          },
                          child: Text("후원하기", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                        ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
