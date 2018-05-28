import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'list.dart';

///HomePage
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'HomePage',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new Scaffold(
        body: new WeatherHome(),
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/list': (BuildContext context) => new ListPage()
      },
    );
  }
}

/// WeatherHome
class WeatherHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new WeatherHomeState();
}

///绘制Weather页
class WeatherHomeState extends State<WeatherHome> {
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

  ///今天天气详细信息
  var todayWeather;

  ///forecast list
  List forecast;

  ///下拉刷新使用
  Completer<Null> completer;

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return homeBody();
  }

  ///homeBody
  Widget homeBody() {
    return new RefreshIndicator(
        child: new CustomScrollView(
          primary: true,
          slivers: <Widget>[
            new SliverList(
              delegate: new SliverChildListDelegate(<Widget>[
                weatherBody(),
                timeTips(),
                buildForeCast(),
              ]),
            )
          ],
        ),
        onRefresh: _refreshHandler);
  }

  ///weatherBody
  Widget weatherBody() {
    return new Container(
      ///底部居中对齐
      alignment: Alignment.bottomCenter,
      height: 380.0,

      ///装饰背景图片
      decoration: new BoxDecoration(
        image: new DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
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
          ),
          new Padding(
            padding: new EdgeInsets.symmetric(vertical: 40.0),
          ),
          todayWeatherDetails(),
        ],
      ),
    );
  }

  ///今天的详细天气信息
  Widget todayWeatherDetails() {
    ///计算今天的时间
    DateTime dateTime = new DateTime.now();
    String todayTime = "${dateTime.year}-${dateTime.month}-${dateTime.day} 今天";
    String todayWeatherDetails = "0° ~ 0°";
    if (todayWeather != null) {
      todayWeatherDetails =
          "${todayWeather['minTemp']}° ~ ${todayWeather['maxTemp']}°";
    }
    return new GestureDetector(
      onTap: _goWeatherListPage,
      child: new Container(
        height: 49.0,
        padding: new EdgeInsets.symmetric(vertical: 14.0),
        margin: new EdgeInsets.symmetric(horizontal: 16.0),
        decoration: new BoxDecoration(
          ///Border
          border: new Border(
              top: new BorderSide(
            color: Colors.black38,
            style: BorderStyle.solid,
            width: 0.2,
          )),
        ),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              todayTime,
              style: new TextStyle(color: Colors.black45),
            ),
            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  todayWeatherDetails,
                  style: new TextStyle(color: Colors.black45),
                ),
                new Padding(padding: new EdgeInsets.symmetric(horizontal: 2.0)),
                new Image.asset(
                  'res/icons/arrow-icon.webp',
                  height: 12.0,
                  fit: BoxFit.contain,
                ),
              ],
            )
          ],
        ),
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
            width: 16.0,
            fit: BoxFit.contain,
          ),
          new Text(
            "未来24小时天气预测",
            style: new TextStyle(
              color: Colors.black45,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  ///未来天气视图
  Widget buildForeCast() {
    return new Container(
      height: 260.0,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecast == null ? 0 : forecast.length,
        itemBuilder: (BuildContext context, int index) {
          var forecastItem = forecast[index];
          return buildForeCastItem(forecastItem);
        },
      ),
    );
  }

  ///未来天气视图item
  Widget buildForeCastItem(forecastItem) {
    String forecastWeather = forecastItem['weather'];
    int forecastTemp = forecastItem['temp'];
    int forecaseId = forecastItem['id'];
    int newHour = new DateTime.now().hour;
    return new Container(
      padding: new EdgeInsets.only(left: 6.0, right: 6.0),
      margin: new EdgeInsets.only(left: 8.0, right: 8.0),
      alignment: Alignment.topCenter,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Padding(
            child: new Text("${(newHour + forecaseId * 3) % 24}时",
                style: new TextStyle(
                  color: Colors.black38,
                  fontSize: 16.0,
                )),
            padding: new EdgeInsets.only(top: 12.0, bottom: 12.0),
          ),
          new Image.asset(
            'res/icons/$forecastWeather-icon.webp',
            width: 32.0,
            fit: BoxFit.contain,
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: new Text(
              "$forecastTemp°",
              style: new TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
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
      var data = JSON.decode(responseBody);

      ///更新数据
      setState(() {
        //现在天气信息
        temp = data['result']['now']['temp'];
        String tempWeather = data['result']['now']['weather'];
        weatherImage = 'res/backgrounds/$tempWeather-bg.webp';
        weather = weatherMap[tempWeather];
        //今天天气
        todayWeather = data['result']['today'];
        //设置未来几个小时的天气
        forecast = data['result']['forecast'];
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

  ///去天气预报页面
  void _goWeatherListPage() {
    print("_goWeatherListPage");
    Navigator.pushNamed(context, '/list');
  }
}
