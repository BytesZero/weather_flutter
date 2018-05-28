import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/rendering.dart';

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
  Completer<Null> completer;

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
        body: new RefreshIndicator(
            child: new CustomScrollView(
              slivers: <Widget>[
                new SliverList(
                  delegate: new SliverChildListDelegate(<Widget>[
                    homeBody(),
                    timeTips(),
                    buildForeCast(),
                  ]),
                )
              ],
            ),
            onRefresh: _refreshHandler),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  ///homeBody
  Widget homeBody() {
    return new Container(
      ///顶部居中对齐
      alignment: Alignment.center,
      height: 380.0,

      ///装饰背景图片
      decoration: new BoxDecoration(
        image: new DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.fill,
          image: new AssetImage(weatherImage),
        ),
      ),

      child: new Column(
        ///最小大小，根据children计算
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,

        ///主体居中
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

  ///未来24小时天气提示
  Widget timeTips() {
    return new Container(
      alignment: Alignment.center,
      padding: new EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            'res/icons/time-icon.webp',
            width: 18.0,
            fit: BoxFit.fitWidth,
          ),
          new Text(
            "未来24小时天气预测",
            style: new TextStyle(
              color: Colors.black45,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  ///未来天气视图
  Widget buildForeCast() {
    return new Container(
      height: 100.0,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          buildForeCastItem(),
          buildForeCastItem(),
          buildForeCastItem(),
          buildForeCastItem(),
          buildForeCastItem(),
          buildForeCastItem(),
          buildForeCastItem()
        ],
      ),
    );
  }

  Widget buildForeCastItem() {
    return new Container(
      padding: new EdgeInsets.only(left: 6.0, right: 6.0),
      margin: new EdgeInsets.only(left: 6.0, right: 6.0),
      alignment: Alignment.center,
      decoration: new BoxDecoration(
        color: Colors.blue[500],
        border: new Border.all(color: Colors.black45, width: 0.5),
        borderRadius: new BorderRadius.circular(5.0),
      ),
      child: new Text("CastItem"),
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

    ///完成下拉刷新
    if (completer != null && !completer.isCompleted) {
      completer.complete(null);
    }
  }

  ///下拉刷新
  Future<Null> _refreshHandler() async {
    completer = new Completer<Null>();
    getWeather();
    return completer.future;
  }
}
