import 'package:mongo_dart/mongo_dart.dart';
//import 'dart:convert';

Future getData() async {

  Db db = new Db("mongodb://192.168.0.20:27017/robohorta");
  await db.open();
  await db.authenticate('robohorta', 'qwerty123456');

  print('Connected to database');

  DbCollection coll = db.collection('events');
  var information = await coll.findOne(where.sortBy('start', descending: true));
  await db.close();
  print('Connection Closed');

  var temperature = information['temperature'][0]['degrees'] != null ? information['temperature'][0]['degrees'] : 0 as double;
  var air_humidity = information['air_humidity'][0]['percent'] != null ? information['air_humidity'][0]['percent'] : 0 as double;
  var soil_moisture = information['soil_moisture'][0]['percent'] != null ? information['soil_moisture'][0]['percent'] : 0 as double;

  List<double> result = [temperature, air_humidity, soil_moisture];

//  print(result);

  return result;
}