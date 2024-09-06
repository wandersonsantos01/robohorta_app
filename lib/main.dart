import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'get_data.dart';
import 'processes.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
  MyHomePage({required this.title});

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
      Navigator.of(context, rootNavigator: true).pop('dialog');
    });
  }

  void doIrrigate() {
    _irrigate().then((result) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
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
    setLoading();
    var data = await getData();
    return data;
  }

  _irrigate() async {
    setLoading();
    irrigate();
    await Future.delayed(Duration(seconds: 2));
  }

  void setLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Stack(
            children: <Widget>[
              new Container(
                  decoration: new BoxDecoration(
                      color: Colors.green,
                      // borderRadius: new BorderRadius.circular(10.0)
                  ),
                  width: 300.0,
                  height: 200.0,
                  alignment: AlignmentDirectional.center,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Center(
                        child: new SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: new CircularProgressIndicator(
                            value: null,
                            strokeWidth: 7.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      new Container(
                        margin: const EdgeInsets.only(top: 25.0),
                        child: new Center(
                          child: new Text(
                            "Loading ...",
                            style: new TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
    // new Future.delayed(new Duration(seconds: 3), () {
    //   Navigator.pop(context); //pop dialog
    //   initState();
    // });
  }

  Widget firstCard(
      last_reading_temperature,
      last_reading_air_humidity,
      last_reading_soil_moisture,
      last_reading_start,
      last_irrigation_temperature,
      last_irrigation_air_humidity,
      last_irrigation_soil_moisture,
      last_irrigation_start
      ) {
    return Center(
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Card(
            elevation: 5,
            margin: new EdgeInsets.only(top: 12, right: 5, left: 5),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: Card(
                        margin: new EdgeInsets.only(top: 7, right: 24, left: 10),
                        elevation: 0,
                        child: RichText(
                          // textAlign: TextAlign.left,
                          text: TextSpan(
                            text: 'Last reading',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ]),
                  Row(
                    children: <Widget>[
                      Card(
                        margin: new EdgeInsets.only(left: 27),
                        elevation: 0,
                        child: RichText(
                          text: TextSpan(
                              text: last_reading_temperature,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 52),
                              children: [TextSpan(text: '\nTemperature', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))]),
                        ),
                      ),
                      Card(
                        margin: new EdgeInsets.only(right: 27, left: 27),
                        elevation: 0,
                        child: RichText(
                          text: TextSpan(
                              text: last_reading_air_humidity,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 52),
                              children: [TextSpan(text: '\nHumidity', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))]),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: RichText(
                          text: TextSpan(
                              text: last_reading_soil_moisture,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 52),
                              children: [TextSpan(text: '\nSoil Moisture', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))]),
                        ),
                      ),
                    ],
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Card(
                        margin: new EdgeInsets.only(right: 24, bottom: 10, top: 7),
                        elevation: 0,
                        child: RichText(
                          textAlign: TextAlign.right,
                          text: TextSpan(
                            text: last_reading_start,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45, fontSize: 12),
                          ),
                        ),
                      ),
                    )
                  ]),
            ]),
          ),
          Card(
            elevation: 5,
            margin: new EdgeInsets.only(top: 20, right: 5, left: 5),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: Card(
                        margin: new EdgeInsets.only(right: 24, top: 7, left: 10),
                        elevation: 0,
                        child: RichText(
                          // textAlign: TextAlign.left,
                          text: TextSpan(
                            text: 'Last irrigation - ' + last_irrigation_start,
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ]),
                  Row(
                    children: <Widget>[
                      Card(
                        margin: new EdgeInsets.only(left: 27),
                        elevation: 0,
                        child: RichText(
                          text: TextSpan(
                              text: last_irrigation_temperature,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 52),
                              children: [TextSpan(text: '\nTemperature', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))]),
                        ),
                      ),
                      Card(
                        margin: new EdgeInsets.only(right: 27, left: 27),
                        elevation: 0,
                        child: RichText(
                          text: TextSpan(
                              text: last_irrigation_air_humidity,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 52),
                              children: [TextSpan(text: '\nHumidity', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))]),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: RichText(
                          text: TextSpan(
                              text: last_irrigation_soil_moisture,
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 52),
                              children: [TextSpan(text: '\nSoil Moisture', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10))]),
                        ),
                      ),
                    ],
                  )
            ]),
          ),
          const _Dashboard(),
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var last_reading_temperature, last_irrigation_temperature = '0°';
    var last_reading_air_humidity, last_irrigation_air_humidity = '0°';
    var last_reading_soil_moisture, last_irrigation_soil_moisture = '0%';
    var last_reading_start, last_irrigation_start = "21/01/1900 00:00:00";

    if (_result != null) {
      last_reading_temperature = _result.last_reading_temperature.round().toString() + '°';
      last_reading_air_humidity = _result.last_reading_air_humidity.round().toString() + '%';
      last_reading_soil_moisture = _result.last_reading_soil_moisture.round().toString() + '%';

      // @ATENÇÃO: CRIAR FUNÇÃO PARA FORMATAR DATA
      DateFormat last_reading_formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
      String last_reading_start_aux = last_reading_formatter.format(_result.last_reading_start);
      last_reading_start = "$last_reading_start_aux";

      last_irrigation_temperature = _result.last_irrigation_temperature.round().toString() + '°';
      last_irrigation_air_humidity = _result.last_irrigation_air_humidity.round().toString() + '%';
      last_irrigation_soil_moisture = _result.last_irrigation_soil_moisture.round().toString() + '%';

      // @ATENÇÃO: CRIAR FUNÇÃO PARA FORMATAR DATA
      DateFormat last_irrigation_formatter = DateFormat('dd/MM HH:mm');
      String last_irrigation_start_aux = last_irrigation_formatter.format(_result.last_irrigation_start);
      last_irrigation_start = "$last_irrigation_start_aux";
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[firstCard(
              last_reading_temperature,
              last_reading_air_humidity,
              last_reading_soil_moisture,
              last_reading_start,
              last_irrigation_temperature,
              last_irrigation_air_humidity,
              last_irrigation_soil_moisture,
              last_irrigation_start
          )],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end, // Aligns buttons to the right
        children: [
          FloatingActionButton(
            onPressed: initState,
            tooltip: 'Update',
            child: Icon(Icons.update),
          ),
          SizedBox(width: 10.0), // Adds a small spacing between buttons
          FloatingActionButton(
            onPressed: doIrrigate,
            tooltip: 'Irrigate',
            child: Icon(Icons.invert_colors), // You can change the icon here
          ),
        ],
      ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard();

  String get last_irrigation_start => '';
  String get last_irrigation_temperature => '';
  String get last_irrigation_air_humidity => '';
  String get last_irrigation_soil_moisture => '';

  /**
   * @CONTINUAR:
   *  - CRIAR FUNÇÃO PARA RETORNAR COMPONENTE COM DADOS DA API
   *  - CRIAR LAÇO DE REPETIÇÃO COM DADOS RETORNADOS
   */
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: new EdgeInsets.only(top: 20, right: 5, left: 5),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Card(
                  margin: new EdgeInsets.only(right: 24, top: 7, left: 10),
                  elevation: 0,
                  child: RichText(
// textAlign: TextAlign.left,
                    text: TextSpan(
                      text: 'Last irrigation - ' + last_irrigation_start,
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ]),
            Row(
              children: <Widget>[
                Card(
                  margin: new EdgeInsets.only(left: 27),
                  elevation: 0,
                  child: RichText(
                    text: TextSpan(
                        text: last_irrigation_temperature,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 52),
                        children: [
                          TextSpan(text: '\nTemperature',
                              style: TextStyle(color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10))
                        ]),
                  ),
                ),
                Card(
                  margin: new EdgeInsets.only(right: 27, left: 27),
                  elevation: 0,
                  child: RichText(
                    text: TextSpan(
                        text: last_irrigation_air_humidity,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 52),
                        children: [
                          TextSpan(text: '\nHumidity',
                              style: TextStyle(color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10))
                        ]),
                  ),
                ),
                Card(
                  elevation: 0,
                  child: RichText(
                    text: TextSpan(
                        text: last_irrigation_soil_moisture,
                        style: TextStyle(fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 52),
                        children: [
                          TextSpan(text: '\nSoil Moisture',
                              style: TextStyle(color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10))
                        ]),
                  ),
                ),
              ],
            )
          ]),
    );
  }
}