import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'list.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

///HomePage
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'HomePage',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: WeatherHome(),
      ),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/list': (BuildContext context) => new ListPage(
              locationCity: WeatherHomeState.locationCity,
            ),
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
  //位置信息
  LocationData _currentLocation;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  Location _location = new Location();

  //城市
  static String locationCity = '西安市';

  //温度
  var temp = 0;

  //天气描述
  var weather = '数据获取中...';

  //天气描述对应的背景图片
  var weatherImage = 'res/backgrounds/sunny-bg.webp';

  //天气转换的映射
  var weatherMap = {
    'sunny': '晴天',
    'cloudy': '多云',
    'overcast': '阴',
    'lightrain': '小雨',
    'heavyrain': '大雨',
    'snow': '雪'
  };

  //今天天气详细信息
  var todayWeather;

  //forecast list
  List forecast;

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
        child: CustomScrollView(
          primary: true,
          slivers: <Widget>[
            new SliverList(
              delegate: SliverChildListDelegate(<Widget>[
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
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.fill,
          image: AssetImage(weatherImage),
        ),
      ),

      child: Column(
        ///最小大小，根据children计算
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,

        ///主体居中
        children: <Widget>[
          buildLocation(),
          new Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),

          ///温度
          new Text(
            "$temp°",
            style: TextStyle(fontSize: 64.0),
          ),

          ///天气描述
          new Text(
            weather,
            style: TextStyle(fontSize: 18.0, color: Colors.black38),
          ),
          new Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
          ),
          todayWeatherDetails(),
        ],
      ),
    );
  }

  ///位置信息
  Widget buildLocation() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.asset(
              'res/icons/location-icon.webp',
              height: 15.0,
              fit: BoxFit.contain,
            ),
            new Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
            new Text(
              '$locationCity',
              style: TextStyle(fontSize: 16.0, color: Colors.black45),
            ),
          ],
        ),
        new Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
        new GestureDetector(
          onTap: _getLocation,
          child: Text("点击更新位置"),
        )
      ],
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
      child: Container(
        height: 49.0,
        padding: EdgeInsets.symmetric(vertical: 14.0),
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          ///Border
          border: Border(
              top: BorderSide(
            color: Colors.black38,
            style: BorderStyle.solid,
            width: 0.2,
          )),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              todayTime,
              style: TextStyle(color: Colors.black45),
            ),
            new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new Text(
                  todayWeatherDetails,
                  style: TextStyle(color: Colors.black45),
                ),
                new Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
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
      padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            'res/icons/time-icon.webp',
            width: 16.0,
            fit: BoxFit.contain,
          ),
          new Text(
            "未来24小时天气预测",
            style: TextStyle(
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
      height: 132.0,
      child: ListView.builder(
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
    var itemTime =
        forecaseId == 0 ? '现在' : '${(newHour + forecaseId * 3) % 24}时';
    return new Container(
      padding: EdgeInsets.only(left: 6.0, right: 6.0),
      margin: EdgeInsets.only(left: 8.0, right: 8.0),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Padding(
            child: Text("$itemTime",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 16.0,
                )),
            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
          ),
          new Image.asset(
            'res/icons/$forecastWeather-icon.webp',
            width: 32.0,
            fit: BoxFit.contain,
          ),
          new Padding(
            padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Text(
              "$forecastTemp°",
              style: TextStyle(
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
    // var uri = Uri.parse(
    //     'https://test-miniprogram.com/api/weather/now?city=$locationCity');
    /// 由于动态接口停止服务，所以改为固定模拟数据
    var uri = Uri.parse(
        'https://raw.githubusercontent.com/yy1300326388/weather_flutter/master/api/weather_now.json');
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var responseBody = await response.transform(utf8.decoder).join();
      print("responseBody: $responseBody");
      var data = json.decode(responseBody);

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
  }

  ///下拉刷新
  Future<void> _refreshHandler() async {
    return getWeather();
  }

  ///去天气预报页面
  void _goWeatherListPage() {
    print("_goWeatherListPage");
    Navigator.pushNamed(context, '/list');
  }

  ///获取位置信息
  Future<void> _getLocation() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        final snackBar = new SnackBar(content: Text("未开启定位服务"));
        Scaffold.of(context).showSnackBar(snackBar);
        return;
      }
    }
    // 判断权限
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        final snackBar = new SnackBar(content: Text("未开启定位权限"));
        Scaffold.of(context).showSnackBar(snackBar);
        return;
      }
    }
    var error = '成功';
    try {
      //获取经纬度
      _currentLocation = await _location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }
      _currentLocation = null;
    }
    print(error);

    if (_currentLocation != null) {
      var latitude = _currentLocation.latitude;
      var longitude = _currentLocation.longitude;
      //获取city
      var uri = Uri.parse(
          'http://apis.map.qq.com/ws/geocoder/v1/?location=$latitude,$longitude&key=ZUHBZ-IUNEF-OTUJD-JBHX3-3YZ6Z-I7FSL');
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var responseBody = await response.transform(utf8.decoder).join();
        print("responseBody: $responseBody");
        var data = json.decode(responseBody);
        var city = data['result']['address_component']['city'];
        if (city != null) {
          if (locationCity != city) {
            getWeather();
          }
          //更新城市
          setState(() {
            locationCity = city;
          });
          final snackBar = new SnackBar(content: Text("获取位置信息，更新成功"));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      }
    } else {
      final snackBar = new SnackBar(content: Text("位置信息获取失败，请检查一下权限"));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
