import 'package:flutter/material.dart';
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
    return Scaffold(

      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/cloud.JPG"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
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
                    Row(
                      children: [
                        Text(
                          '최고 ',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.Data['main']['temp_max'].toStringAsFixed(0)}°C',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '최저 ',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.Data['main']['temp_min'].toStringAsFixed(0)}°C',
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
            Image.network('http://openweathermap.org/img/wn/' +
                widget.Data['weather'][0]['icon'] +
                '@2x.png'),
            Container(
                padding: EdgeInsets.only(right: 10, top: 10),
                alignment: Alignment.bottomRight,
                child:
                    Text('Last Updated: ${formatter.format(DateTime.now())}')),
            Container(
              decoration: new BoxDecoration(
                boxShadow: [new BoxShadow(
                  color:  Colors.transparent,
                  blurRadius:  3.0,
                )]
              ),
              width: MediaQuery.of(context).size.width - 10,
              child: Card(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'More information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      IntrinsicHeight(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.water_damage,
                            color: Colors.white,
                          ),
                          Column(
                            children: [
                              Text('Humidity'),
                              Text(
                                  '${widget.Data['main']['humidity'].toStringAsFixed(0)}%')
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                          ),
                          Column(
                            children: [
                              Text('Visibility'),
                              Text('${widget.Data['visibility']}')
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.water_damage,
                            color: Colors.white,
                          ),
                          Column(
                            children: [
                              Text('Country'),
                              Text('${widget.Data['sys']['country']}')
                            ],
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      IntrinsicHeight(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          infoSpace(Icons.speed, 'Wind Deg',
                              '${widget.Data['wind']['speed']}'),
                          VerticalDivider(
                            color: Colors.white,
                          ),
                          infoSpace(Icons.rotate_90_degrees_ccw, 'Wind Deg',
                              '${widget.Data['wind']['deg']}')
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
                              'Sunset',
                              sun.format(DateTime.fromMillisecondsSinceEpoch(
                                  widget.Data['sys']['sunset'] * 1000))),
                          VerticalDivider(
                            color: Colors.white,
                          ),
                          infoSpace(
                              Icons.nights_stay,
                              'Sunrise',
                              sun.format(DateTime.fromMillisecondsSinceEpoch(
                                  widget.Data['sys']['sunrise'] * 1000))),
                        ],
                      )),
                    ],
                  ),
                ),
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
              children: [Text(topText), Text(bottomText)],
            ),
          )
        ],
      ),
    );
  }
}
