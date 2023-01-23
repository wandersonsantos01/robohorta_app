import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future getData() async {
  var lastReading = null;
  var lastIrrigation = null;

  var result =  new first_card_data();

  if (dotenv.env['get_data_on'] == 'mongo') {
    // Db db = new Db("mongodb://rsfh01.ddns.net:27999/robohorta"); // DDNS
//  Db db = new Db("mongodb://192.168.0.20:27017/robohorta"); // LOCAL
//  Db db = new Db("mongodb://187.182.181.173:27999/robohorta"); // IP EXTERNO

    // var db = await Db.create("mongodb+srv://" + dotenv.env['username'] + ":" + dotenv.env['password'] + "@" + dotenv.env['host'] + ":" + dotenv.env['port'] + "/" + dotenv.env['database'] + "?<parameters>");
    var db = await Db.create("mongodb+srv://" + dotenv.env['username']! + ":" +
        dotenv.env['password']! + "@" + dotenv.env['host']! + ":" +
        dotenv.env['port']! + "/" + dotenv.env['database']!);
    await db.open();
    // await db.authenticate(dotenv.env['username'], dotenv.env['password']);

    print('Connected to database');

    DbCollection coll = db.collection('events');
    var lastReading = await coll.findOne(
        where.sortBy('start', descending: true));
    var lastIrrigation = await coll.findOne(
        where.eq('status', 'IRRIGATED').sortBy('start', descending: true));
    await db.close();
    print('Connection Closed');

    result.SetFirstCardData(lastReading, lastIrrigation);
  } else if (dotenv.env['get_data_on'] == 'api') {
    try {
      var headers = {
        'tk': dotenv.env['api_token']
      };

      // LAST READING
      var url = dotenv.env['api_url']! + dotenv.env['api_events_uri']! +
          "/SMALL BREAK";
      var requestLastReading = http.Request('GET', Uri.parse(url));

      requestLastReading.headers.addAll(headers);

      http.StreamedResponse responseLastReading = await requestLastReading
          .send();

      if (responseLastReading.statusCode == 200) {
        var lastReadingResponse = await responseLastReading.stream
            .bytesToString();
        lastReading = json.decode(lastReadingResponse)['Items'][0];
      }
      else {
        print(responseLastReading.reasonPhrase);
      }

      // LAST IRRIGATION
      url = dotenv.env['api_url']! + dotenv.env['api_events_uri']! + "/IRRIGATED";
      var requestLastIrrigation = http.Request('GET', Uri.parse(url));

      requestLastIrrigation.headers.addAll(headers);

      http.StreamedResponse responseLastIrrigation = await requestLastIrrigation
          .send();

      if (responseLastIrrigation.statusCode == 200) {
        var lastIrrigationResponse = await responseLastIrrigation.stream
            .bytesToString();
        lastIrrigation = json.decode(lastIrrigationResponse)['Items'][0];
      }
      else {
        print(responseLastIrrigation.reasonPhrase);
      }
      result.SetFirstCardData(lastReading, lastIrrigation);
    } on SocketException {
      // print('SocketException');
      result.SetFirstCardData({}, {});
    } on Error catch (e) {
      // print('Error: $e');
    }
  }

  return result;
}

class first_card_data {
  double last_reading_temperature = 0;
  double last_reading_air_humidity = 0;
  double last_reading_soil_moisture = 0;
  DateTime last_reading_start = DateTime.parse("1900-01-01 00:00:00Z");

  double last_irrigation_temperature = 0;
  double last_irrigation_air_humidity = 0;
  double last_irrigation_soil_moisture = 0;
  DateTime last_irrigation_start = DateTime.parse("1900-01-01 00:00:00Z");

  SetFirstCardData(lastReading, lastIrrigation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('lastReadingTemperature', this.last_reading_temperature);
    prefs.setDouble('lastReadingAirHumidity', this.last_irrigation_air_humidity);
    prefs.setDouble('lastReadingSoilMoisture', this.last_irrigation_soil_moisture);
    prefs.setString('lastReadingStart', this.last_reading_start.toString());

    prefs.setDouble('lastIrrigationTemperature', this.last_irrigation_temperature);
    prefs.setDouble('lastIrrigationAirHumidity', this.last_irrigation_air_humidity);
    prefs.setDouble('lastIrrigationSoilMoisture', this.last_irrigation_soil_moisture);
    prefs.setString('lastIrrigationStart', this.last_irrigation_start.toString());

    var lastReadingTemperature = lastReading['temperature'] != null
        ? lastReading['temperature']['degrees']
        : prefs.getDouble('lastReadingTemperature');
    var lastReadingAirHumidity = lastReading['air_humidity'] != null
        ? lastReading['air_humidity']['percent']
        : prefs.getDouble('lastReadingAirHumidity');
    var lastReadingSoilMoisture = lastReading['soil_moisture'] != null
        ? lastReading['soil_moisture']['percent']
        : prefs.getDouble('lastReadingSoilMoisture');
    var lastReadingStart = lastReading['start'] != null
        ? DateTime.parse(lastReading['start'])
        : DateTime.parse(prefs.getString('lastReadingStart')!);

    this.last_reading_temperature = lastReadingTemperature.toDouble();
    this.last_reading_air_humidity = lastReadingAirHumidity.toDouble();
    this.last_reading_soil_moisture = lastReadingSoilMoisture.toDouble();
    this.last_reading_start = lastReadingStart;

    prefs.setDouble('lastReadingTemperature', lastReadingTemperature);
    prefs.setDouble('lastReadingAirHumidity', lastReadingAirHumidity);
    prefs.setDouble('lastReadingSoilMoisture', lastReadingSoilMoisture);
    prefs.setString('lastReadingStart', lastReadingStart.toString());

    var lastIrrigationTemperature = lastIrrigation['temperature'] != null
        ? lastIrrigation['temperature']['degrees']
        : prefs.getDouble('lastIrrigationTemperature');
    var lastIrrigationAirHumidity = lastIrrigation['air_humidity'] != null
        ? lastIrrigation['air_humidity']['percent']
        : prefs.getDouble('lastIrrigationAirHumidity');
    var lastIrrigationSoilMoisture = lastIrrigation['soil_moisture'] != null
        ? lastIrrigation['soil_moisture']['percent']
        : prefs.getDouble('lastIrrigationSoilMoisture');
    var lastIrrigationStart = lastIrrigation['start'] != null
        ? DateTime.parse(lastIrrigation['start'])
        : DateTime.parse(prefs.getString('lastIrrigationStart')!);

    this.last_irrigation_temperature = lastIrrigationTemperature.toDouble();
    this.last_irrigation_air_humidity = lastIrrigationAirHumidity.toDouble();
    this.last_irrigation_soil_moisture = lastIrrigationSoilMoisture.toDouble();
    this.last_irrigation_start = lastIrrigationStart;

    prefs.setDouble('lastIrrigationTemperature', lastIrrigationTemperature);
    prefs.setDouble('lastIrrigationAirHumidity', lastIrrigationAirHumidity);
    prefs.setDouble('lastIrrigationSoilMoisture', lastIrrigationSoilMoisture);
    prefs.setString('lastIrrigationStart', lastIrrigationStart.toString());

    return this;
  }
}
