import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'dart:convert';

Future getData() async {
  // Db db = new Db("mongodb://rsfh01.ddns.net:27999/robohorta"); // DDNS
//  Db db = new Db("mongodb://192.168.0.20:27017/robohorta"); // LOCAL
//  Db db = new Db("mongodb://187.182.181.173:27999/robohorta"); // IP EXTERNO

  // var db = await Db.create("mongodb+srv://" + dotenv.env['username'] + ":" + dotenv.env['password'] + "@" + dotenv.env['host'] + ":" + dotenv.env['port'] + "/" + dotenv.env['database'] + "?<parameters>");
  var db = await Db.create("mongodb+srv://" + dotenv.env['username'] + ":" + dotenv.env['password'] + "@" + dotenv.env['host'] + ":" + dotenv.env['port'] + "/" + dotenv.env['database']);
  await db.open();
  // await db.authenticate(dotenv.env['username'], dotenv.env['password']);

  print('Connected to database');

  DbCollection coll = db.collection('events');
  var lastReading = await coll.findOne(where.sortBy('start', descending: true));
  var lastIrrigation = await coll.findOne(where.eq('status', 'IRRIGATED').sortBy('start', descending: true));
  await db.close();
  print('Connection Closed');

  var result = new first_card_data();

  var lastReadingTemperature = lastReading['temperature']['degrees'] != null ? lastReading['temperature']['degrees'] : 0 as double;
  var lastReadingAirHumidity = lastReading['air_humidity']['percent'] != null ? lastReading['air_humidity']['percent'] : 0 as double;
  var lastReadingSoilMoisture = lastReading['soil_moisture']['percent'] != null ? lastReading['soil_moisture']['percent'] : 0 as double;
  var lastReadingStart = lastReading['start'] != null ? lastReading['start'] : DateTime.parse("1900-01-01 00:00:00Z");

  result.last_reading_temperature = lastReadingTemperature;
  result.last_reading_air_humidity = lastReadingAirHumidity;
  result.last_reading_soil_moisture = lastReadingSoilMoisture;
  result.last_reading_start = lastReadingStart;

  var lastIrrigationTemperature = lastIrrigation['temperature']['degrees'] != null ? lastIrrigation['temperature']['degrees'] : 0 as double;
  var lastIrrigationAirHumidity = lastIrrigation['air_humidity']['percent'] != null ? lastIrrigation['air_humidity']['percent'] : 0 as double;
  var lastIrrigationSoilMoisture = lastIrrigation['soil_moisture']['percent'] != null ? lastIrrigation['soil_moisture']['percent'] : 0 as double;
  var lastIrrigationStart = lastIrrigation['start'] != null ? lastIrrigation['start'] : DateTime.parse("1900-01-01 00:00:00Z");

  result.last_irrigation_temperature = lastIrrigationTemperature;
  result.last_irrigation_air_humidity = lastIrrigationAirHumidity;
  result.last_irrigation_soil_moisture = lastIrrigationSoilMoisture;
  result.last_irrigation_start = lastIrrigationStart;

  return result;
}

class first_card_data {
  double last_reading_temperature;
  double last_reading_air_humidity;
  double last_reading_soil_moisture;
  DateTime last_reading_start;

  double last_irrigation_temperature;
  double last_irrigation_air_humidity;
  double last_irrigation_soil_moisture;
  DateTime last_irrigation_start;
}
