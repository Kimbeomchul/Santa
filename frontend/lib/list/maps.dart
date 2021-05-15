import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  var lat;
  var lon;

  Future<Position> getLocation() async {
    Position position =
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;
    });
    return position;
  }
  maps(){
    return Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: GoogleMap(initialCameraPosition: CameraPosition(target:LatLng(
            lat,
            lon),
          zoom:18,
        )
        )
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();

  }
  @override
  Widget build(BuildContext context) {
    return maps();
  }
}
