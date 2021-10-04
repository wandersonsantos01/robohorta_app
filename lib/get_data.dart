import 'package:mongo_dart/mongo_dart.dart';
//import 'dart:convert';

Future getData() async {
  Db db = new Db("mongodb://rsfh01.ddns.net:27999/robohorta"); // DDNS
//  Db db = new Db("mongodb://192.168.0.20:27017/robohorta"); // LOCAL
//  Db db = new Db("mongodb://187.182.181.173:27999/robohorta"); // IP EXTERNO

  await db.open();
  await db.authenticate('robohorta', 'qwerty123456');

  print('Connected to database');

  DbCollection coll = db.collection('events');
  var information = await coll.findOne(where.sortBy('start', descending: true));
  await db.close();
  print('Connection Closed');

  var temperature = information['temperature']['degrees'] != null ? information['temperature']['degrees'] : 0 as double;
  var air_humidity = information['air_humidity']['percent'] != null ? information['air_humidity']['percent'] : 0 as double;
  var soil_moisture = information['soil_moisture']['percent'] != null ? information['soil_moisture']['percent'] : 0 as double;
  var start = information['start'] != null ? information['start'] : DateTime.parse("1900-01-01 00:00:00Z");

  var result = new first_card_data();
  result.temperature = temperature;
  result.air_humidity = air_humidity;
  result.soil_moisture = soil_moisture;
  result.start = start;
//  List<double> result = [temperature, air_humidity, soil_moisture];

//  print(result);

  return result;
}

class first_card_data {
  double temperature;
  double air_humidity;
  double soil_moisture;
  DateTime start;
}
