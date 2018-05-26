import 'package:flutter/material.dart';

/// WeaterHome
class WeaterHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new WeatherHomeState();
}

///绘制Weather页
class WeatherHomeState extends State<WeaterHome> {
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
            "12°",
            style: new TextStyle(fontSize: 64.0),
          ),
          new Text(
            "晴天",
            style: new TextStyle(fontSize: 18.0, color: Colors.black38),
          )
        ],
      ),
    );
  }
}
