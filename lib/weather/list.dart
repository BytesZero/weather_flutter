import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

///未来7天天气列表
class ListPage extends StatelessWidget {
  ListPage({Key? key, this.locationCity = '西安市'}) : super(key: key);

  //城市
  final String locationCity;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "List Page",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text("未来一周天气"),
          centerTitle: true,
        ),
        body: WeatherListBody(
          locationCity: locationCity,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

///天气预报列表
class WeatherListBody extends StatefulWidget {
  //城市

  WeatherListBody({Key? key, required this.locationCity}) : super(key: key);

  final String locationCity;

  @override
  State<StatefulWidget> createState() => new WeatherListBodyState();
}

///天气预报列表 状态
class WeatherListBodyState extends State<WeatherListBody> {
  //周天气数据
  List? weekWeather;

  //星期对应转换数据
  var weekDayData = {
    1: '星期一',
    2: '星期二',
    3: '星期三',
    4: '星期四',
    5: '星期五',
    6: '星期六',
    7: '星期日'
  };

  @override
  void initState() {
    super.initState();
    getWeekWeather();
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: weekWeather?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return buildWeekWeatherItem(weekWeather![index]);
          }),
      onRefresh: _onRefresh,
    );
  }

  ///周天气视图Item
  Widget buildWeekWeatherItem(weatherItem) {
    int itemId = weatherItem['id'];
    var itemWeather = weatherItem['weather'];
    var minTemp = weatherItem['minTemp'];
    var maxTemp = weatherItem['maxTemp'];
    //计算时间
    var now = new DateTime.now();
    var date = new DateTime(now.year, now.month, now.day + itemId);
    var weekday = itemId == 0 ? '今天' : weekDayData[date.weekday];
    var dayTime = '${date.year}-${date.month}-${date.day}';
    //转换图标
    var itemWeatherIcon = 'res/icons/$itemWeather-icon.webp';

    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.grey, width: 0.2, style: BorderStyle.solid))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "$weekday",
                style: TextStyle(fontSize: 20.0),
              ),
              new Text(
                "$dayTime",
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
          new Text("$minTemp° ~ $maxTemp°"),
          new Image.asset(
            itemWeatherIcon,
            width: 32.0,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  ///刷新
  Future<void> _onRefresh() async {
    return getWeekWeather();
  }

  /// 获取一周的天气
  void getWeekWeather() async {
    var client = new HttpClient();
    // var url =
    //     Uri.parse("https://test-miniprogram.com/api/weather/future?city=${widget
    //     .locationCity}&time=${new DateTime
    //     .now().millisecondsSinceEpoch}");
    /// 由于动态接口停止服务，所以改为固定模拟数据
    var url = Uri.parse(
        "https://raw.githubusercontent.com/yy1300326388/weather_flutter/master/api/weather_future.json");
    var request = await client.getUrl(url);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var responseBody = await response.transform(utf8.decoder).join();
      var data = json.decode(responseBody);
      setState(() {
        weekWeather = data['result'];
      });
    }
  }
}
