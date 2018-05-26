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
      title:'WeaterHome',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Weather Home Page"),
          centerTitle: true,
        ),
        body: new Center(
          child: new Text("Hello World"),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

}