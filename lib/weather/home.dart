import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

/// WeaterHome
class WeaterHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new WeatherHomeState();
}

///绘制Weather页
class WeatherHomeState extends State<WeaterHome> {
  var temp = 0;
  var weather = "null";

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'WeaterHome',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Weather Home Page",
            style: new TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFCBEEFD),
          elevation: 0.0,
        ),
        body: homeBody(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  ///homeBody
  Widget homeBody() {
    return new Container(
      height: 380.0,
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new NetworkImage(
              'https://raw.githubusercontent.com/udacity/cn-wechat-weather/2-4/images/sunny-bg.png'),
        ),
      ),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "$temp°",
            style: new TextStyle(fontSize: 64.0),
          ),
          new Text(
            weather,
            style: new TextStyle(fontSize: 18.0, color: Colors.black38),
          )
        ],
      ),
    );
  }

  ///通过网络获取天气
  void getWeather() async {
    var httpClient = new HttpClient(); //创建client
    var uri =
        Uri.parse('https://test-miniprogram.com/api/weather/now?city=北京市');
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var responseBody = await response.transform(UTF8.decoder).join();
      print("responseBody: $responseBody");
      var date = JSON.decode(responseBody);
      setState(() {
        temp = date['result']['now']['temp'];
        weather = date['result']['now']['weather'];
      });
    }
  }
}
