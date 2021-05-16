import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:santa_front/mountain/mt_detail.dart';
import 'package:santa_front/mountain/mt_info.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller =Completer();
  static CameraPosition _googlePos;
  
  BitmapDescriptor _markerIcon;
  LatLng _googleCenter;
  
  var lat;
  var lon;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  
    
    _googlePos = CameraPosition(target: LatLng(36.228989,127.762536),  // 대한민국
    zoom:  7.2,
    );
    _googleCenter = LatLng(37.898989,129.362536);
  }
  
  Future<Position> getLocation() async {
    Position position =
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
    return position;
  }

  Set<Marker> _createMarker(){
    return <Marker>[
      Marker(
        markerId: MarkerId("가리산"),
        position: LatLng(37.87518538027297, 127.96067792711663),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '가리산',
          snippet: "산행거리 : 9.6㎞(약 5시간)\n산행코스 : 홍천고개(580m)-681봉-등잔봉-새득이봉-가삽고개-3봉-2봉-1봉(가리산정상)-무쇠말재-가리산휴양림-매표소-예지수련원도로",
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("가리산")));
          }
        ),
      ),
      // INFO
      // ●산행거리(시간) : 9.6㎞(약 5시간)
      // ●산행코스:홍천고개(580m)-681봉-등잔봉-새득이봉-가삽고개-3봉-2봉-1봉(가리산정상)-무쇠말재-가리산휴양림-매표소-예지수련원도로
      //

      Marker(
        markerId: MarkerId("가리왕산"),
        position: LatLng(37.46281262933276, 128.56343493929762),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '가리왕산',
          snippet: "산행거리 : 9.4㎞(약 5시간)\n산행코스 : 장구목이 입구-임도-정상 삼거리-가리왕산-장구목이 입구 ",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("가리왕산")));
            }
        ),
      ),
      // INFO
      // ●산행거리(시간) : 9.4㎞(약 5시간)
      // ●산행코스:장구목이 입구-임도-정상 삼거리-가리왕산-장구목이 입구
      //

      Marker(
        markerId: MarkerId("공작산"),
        position: LatLng(37.716105330257804, 128.0100592589968),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '공작산',
          snippet: "산행거리 : 5.4㎞(약 3시간)\n산행코스 : 공작현-406번국도-공작산 입구-공작릉-능선삼거리-공작산 정상-능선삼거리-공작현",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("공작산")));
            }
        ),
      ),
      // INFO
      // ●산행거리(시간) : 5.4㎞(약 3시간)
      // ●산행코스:공작현-406번국도-공작산 입구-공작릉-능선삼거리-공작산 정상-능선삼거리-공작현
      //
      Marker(
        markerId: MarkerId("방태산"),
        position: LatLng(37.8953604584265, 128.35587629103452),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '방태산',
          snippet: "산행거리 : 12.3㎞(약 7시간)\n산행코스 : 개인약수산장-개인약수터-이정표-정상 주억봉-구룡덕봉-샘터방향 하산-개인약수산장 ",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("방태산")));
            }
        ),
      ),
      // INFO
      // ●산행거리(시간): 12.3㎞(약 7시간)
      // ●산행코스:개인약수산장-개인약수터-이정표-정상 주억봉-구룡덕봉-샘터방향 하산-개인약수산장
      //
      //
      Marker(
        markerId: MarkerId("명성산"),
        position: LatLng(38.10758174841286, 127.33750978722422),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '명성산',
          snippet: "산행거리 : 5.5㎞(약 4시간)\n산행코스 : 주차장-비선폭포-등룡폭포-억새군락지-팔각정-나무계단-책바위-비선폭포 ",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("명성산")));
            }

        ),
      ),
      // INFO
      // ●산행거리(시간) : 5.5㎞(약 4시간)
      // ●산행코스:주차장-비선폭포-등룡폭포-억새군락지-팔각정-나무계단-책바위-비선폭포
      //
      Marker(
        markerId: MarkerId("가야산"),
        position: LatLng(35.822655215920044, 128.11806500457826),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '가야산',
          snippet: "산행거리 : 9.1㎞(약 5시간)\n산행코스 : 백운동탐방지원센터-용기골-백운교(1,2,3,4)-백운암지-서성재-칠불봉-상왕봉 정상(우두봉)-토신골-가야산탐방지원센터(토신골공원 지킴터)-용탑선원-해인사-성보박물관-치인주차장 ",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("가야산")));
            }
        ),
      ),
      // INFO
      // ●산행거리(시간) : 9.1㎞(약 5시간)
      // ●산행코스:백운동탐방지원센터-용기골-백운교(1,2,3,4)-백운암지-서성재-칠불봉-상왕봉 정상(우두봉)-토신골-가야산탐방지원센터(토신골공원 지킴터)-용탑선원-해인사-성보박물관-치인주차장
      //
      Marker(
        markerId: MarkerId("천성산"),
        position: LatLng(35.420807433167326, 129.11215925578472),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '천성산',
          snippet: "산행거리 : 약 10㎞(약 5시간)\n산행코스 : 내원사매표소주차장-중앙능선-천성산제2봉-짚북재-성불암계곡-내원사매표소주차장 ",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("천성산")));
            }
        ),
      ),
      // INFO
      // ●산행거리(시간) : 약 10㎞(약 5시간)
      // ●산행코스:내원사매표소주차장-중앙능선-천성산제2봉-짚북재-성불암계곡-내원사매표소주차장
      //
      Marker(
        markerId: MarkerId("덕룡산"),
        position: LatLng(34.54049906773597, 126.70236024331193),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '덕룡산',
          snippet: "산행거리 : 약 12㎞(약 9시간)\n산행코스 : 소석문-덕룡산 동봉-서봉-주작산-작천소령-401봉-오소재 ",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("덕룡산")));
            }
        ),
      ),
      // INFO
      // ●산행거리(시간) : 약 12㎞(약 9시간)
      // ●산행코스:소석문-덕룡산 동봉-서봉-주작산-작천소령-401봉-오소재
      //
      Marker(
        markerId: MarkerId("황매산"),
        position: LatLng(35.49635621098109, 127.97453028414732),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '황매산',
          snippet: "산행거리 : 약 14㎞(약 6시간)\n산행코스 : 장박마을-975m봉-황매산 정상-베틀봉-장승 삼거리-목장-덕만주차장 ",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("황매산")));
            }
        ),
      ),
      // INFO
      // ●산행거리(시간) : 약 14㎞(약 6시간)
      // ●산행코스:장박마을-975m봉-황매산 정상-베틀봉-장승 삼거리-목장-덕만주차장
      //
      Marker(
        markerId: MarkerId("무등산"),
        position: LatLng(35.13472952441696, 126.9885838949423),
        icon: _markerIcon,
        infoWindow: InfoWindow(
          title: '무등산',
          snippet: "산행거리 : 8㎞(약 5시간)\n산행코스 : 중지마을-샘터-장불재-입석대-서석대-중봉-중머리재-용추폭포삼거리-중지마을 ",
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => MountainInfo("무등산")));
            }
        ),
      ),
      // INFO
      // ●산행거리(시간) : 8㎞(약 5시간)
      // ●산행코스:중지마을-샘터-장불재-입석대-서석대-중봉-중머리재-용추폭포삼거리-중지마을
      //
    ].toSet();

  }

  maps(){
    return Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: GoogleMap(
            mapType: MapType.normal,
            markers: _createMarker(),
            initialCameraPosition: _googlePos,
            onMapCreated: (GoogleMapController controller ){
              _controller.complete(controller);
            },
        ),
        );

  }

  @override
  Widget build(BuildContext context) {
    return maps();
  }
}
