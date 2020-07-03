import 'package:flutter/material.dart';
import 'get_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoboHorta Dashboard',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightGreen,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'RoboHorta Dashboard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var _result;

  @override
  void initState() {
    // This is the proper place to make the async calls
    // This way they only get called once

    // During development, if you change this code,
    // you will need to do a full restart instead of just a hot reload

    // You can't use async/await here,
    // We can't mark this method as async because of the @override
    _getData().then((result) {
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
      setState(() {
        _result = result;
      });
    });
  }

  _incrementCounter() {
    setState(() async {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.

      _counter++;
    });
  }

  _getData() async {
      var data = await getData();

//      print(data);

      return data;
  }


  Widget firstCard(temperature, air_humidity, soil_moisture) {
    return Center(
      child: Card(
        elevation: 5,
        child:
            Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Card(
                    margin: new EdgeInsets.only(left: 27),
                    elevation: 0,
                    child: RichText(
                      text: TextSpan(
                          text: temperature,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 52),
                          children: [
                            TextSpan(
                                text: '\nTemperature',
                                style: TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))
                          ]),
                    ),
                  ),
                  Card(
                    margin: new EdgeInsets.only(right: 27, left: 27),
                    elevation: 0,
                    child: RichText(
                      text: TextSpan(
                          text: air_humidity,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 52),
                          children: [
                            TextSpan(
                                text: '\nHumidity',
                                style: TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))
                          ]),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    child: RichText(
                      text: TextSpan(
                          text: soil_moisture,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 52),
                          children: [
                            TextSpan(
                                text: '\nSoil Moisture',
                                style: TextStyle(
                                    color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))
                          ]),
                    ),
                  ),
                  //            ButtonBar(
                  //              children: <Widget>[
                  //                FlatButton(
                  //                  child: const Text('UPDATE'),
                  //                  onPressed: () {/* ... */},
                  //                ),
                  //              ],
                  //            ),
                ],
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var temperature = '0°';
    var air_humidity = '0°';
    var soil_moisture = '0%';

    if (_result != null) {
      temperature = _result[0].round().toString() + '°';
      air_humidity = _result[1].round().toString() + '%';
      soil_moisture = _result[2].round().toString() + '%';
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[firstCard(temperature, air_humidity, soil_moisture)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: 'Increment',
        child: Icon(Icons.update),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
