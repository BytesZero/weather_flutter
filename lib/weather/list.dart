import 'package:flutter/material.dart';

///未来7天天气列表
class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "List Page",
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new Scaffold(
        appBar: new AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: new Text("List Page"),
          centerTitle: true,
        ),
        body: new WeatherListBody(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

///天气预报列表
class WeatherListBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new WeatherListBodyState();
}

///天气预报列表 状态
class WeatherListBodyState extends State<WeatherListBody> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text("List"),
    );
  }
}
