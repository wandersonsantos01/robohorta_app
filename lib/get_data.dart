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

  List<double> result = [information['temperature'][0]['degrees'], information['air_humidity'][0]['percent'], information['soil_moisture'][0]['percent']];

//  print(result);

  return result;
}