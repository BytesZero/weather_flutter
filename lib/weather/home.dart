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
          title: new Text("Weather Home Page"),
          centerTitle: true,
        ),
        body: homeBody(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  ///homeBody
  Widget homeBody() {
    return new Container(
      alignment: Alignment.topCenter,
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "12°",
            style: new TextStyle(fontSize: 48.0),
          ),
          new Text(
            "晴天",
            style: new TextStyle(fontSize: 16.0, color: Colors.black38),
          )
        ],
      ),
    );
  }
}
