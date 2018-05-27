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
  ///温度
  var temp = 0;

  ///天气描述
  var weather = '数据获取中...';

  ///天气描述对应的背景图片
  var weatherImage = 'res/backgrounds/sunny-bg.webp';

  ///天气转换的映射
  var weatherMap = {
    'sunny': '晴天',
    'cloudy': '多云',
    'overcast': '阴',
    'lightrain': '小雨',
    'heavyrain': '大雨',
    'snow': '雪'
  };

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
//        appBar: new AppBar(
//          title: new Text(
//            "Weather Home Page",
//            style: new TextStyle(color: Colors.black87),
//          ),
//          centerTitle: true,
//          backgroundColor: const Color(0xFFCBEEFD),
//          elevation: 0.0,
//        ),
        body: homeBody(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  ///homeBody
  Widget homeBody() {
    return new Container(
      ///顶部居中对齐
      alignment: Alignment.topCenter,

      ///装饰背景图片
      decoration: new BoxDecoration(
        image: new DecorationImage(
          alignment: Alignment.topCenter,
          image: new AssetImage(weatherImage),
        ),
      ),
      padding: new EdgeInsets.only(top: 140.0),

      ///child 距离顶部140
      child: new Column(
        ///最小大小，根据children计算
        mainAxisSize: MainAxisSize.min,

        ///主体居中
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          ///温度
          new Text(
            "$temp°",
            style: new TextStyle(fontSize: 64.0),
          ),

          ///天气描述
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
    ///创建client
    var httpClient = new HttpClient();
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
        String tempWeather = date['result']['now']['weather'];
        weatherImage = 'res/backgrounds/$tempWeather-bg.webp';
        weather = weatherMap[tempWeather];
      });
    }
  }
}
