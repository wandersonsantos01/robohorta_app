import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future getData() async {
  var lastReading = null;
  var lastIrrigation = null;

  var result =  new first_card_data();

  if (dotenv.env['get_data_on'] == 'mongo') {
    // Db db = new Db("mongodb://rsfh01.ddns.net:27999/robohorta"); // DDNS
//  Db db = new Db("mongodb://192.168.0.20:27017/robohorta"); // LOCAL
//  Db db = new Db("mongodb://187.182.181.173:27999/robohorta"); // IP EXTERNO

    // var db = await Db.create("mongodb+srv://" + dotenv.env['username'] + ":" + dotenv.env['password'] + "@" + dotenv.env['host'] + ":" + dotenv.env['port'] + "/" + dotenv.env['database'] + "?<parameters>");
    var db = await Db.create("mongodb+srv://" + dotenv.env['username'] + ":" +
        dotenv.env['password'] + "@" + dotenv.env['host'] + ":" +
        dotenv.env['port'] + "/" + dotenv.env['database']);
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
    var headers = {
      'tk': dotenv.env['api_token']
    };

    // LAST READING
    var url = dotenv.env['api_url'] + dotenv.env['api_events_uri'] + "/SMALL BREAK";
    var requestLastReading = http.Request('GET', Uri.parse(url));

    requestLastReading.headers.addAll(headers);

    http.StreamedResponse responseLastReading = await requestLastReading.send();

    if (responseLastReading.statusCode == 200) {
      var lastReadingResponse = await responseLastReading.stream.bytesToString();
      lastReading = json.decode(lastReadingResponse)['Items'][0];
    }
    else {
      print(responseLastReading.reasonPhrase);
    }

    // LAST IRRIGATION
    url = dotenv.env['api_url'] + dotenv.env['api_events_uri'] + "/IRRIGATED";
    var requestLastIrrigation = http.Request('GET', Uri.parse(url));

    requestLastIrrigation.headers.addAll(headers);

    http.StreamedResponse responseLastIrrigation = await requestLastIrrigation.send();

    if (responseLastIrrigation.statusCode == 200) {
      var lastIrrigationResponse = await responseLastIrrigation.stream.bytesToString();
      lastIrrigation = json.decode(lastIrrigationResponse)['Items'][0];
    }
    else {
      print(responseLastIrrigation.reasonPhrase);
    }

    print(lastReading);
    print(lastIrrigation);
    result.SetFirstCardData(lastReading, lastIrrigation);
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

  SetFirstCardData(lastReading, lastIrrigation) {
    if (lastReading != null || lastIrrigation != null) {
      var lastReadingTemperature = lastReading['temperature']['degrees'] != null
          ? lastReading['temperature']['degrees']
          : 0 as double;
      var lastReadingAirHumidity =
          lastReading['air_humidity']['percent'] != null
              ? lastReading['air_humidity']['percent'].toDouble()
              : 0 as double;
      var lastReadingSoilMoisture =
          lastReading['soil_moisture']['percent'] != null
              ? lastReading['soil_moisture']['percent'].toDouble()
              : 0 as double;
      var lastReadingStart = lastReading['start'] != null
          ? DateTime.parse(lastReading['start'])
          : DateTime.parse("1900-01-01 00:00:00Z");

      this.last_reading_temperature = lastReadingTemperature;
      this.last_reading_air_humidity = lastReadingAirHumidity;
      this.last_reading_soil_moisture = lastReadingSoilMoisture;
      this.last_reading_start = lastReadingStart;

      var lastIrrigationTemperature =
          lastIrrigation['temperature']['degrees'] != null
              ? lastIrrigation['temperature']['degrees']
              : 0 as double;
      var lastIrrigationAirHumidity =
          lastIrrigation['air_humidity']['percent'] != null
              ? lastIrrigation['air_humidity']['percent'].toDouble()
              : 0 as double;
      var lastIrrigationSoilMoisture =
          lastIrrigation['soil_moisture']['percent'] != null
              ? lastIrrigation['soil_moisture']['percent'].toDouble()
              : 0 as double;
      var lastIrrigationStart = lastIrrigation['start'] != null
          ? DateTime.parse(lastIrrigation['start'])
          : DateTime.parse("1900-01-01 00:00:00Z");

      this.last_irrigation_temperature = lastIrrigationTemperature;
      this.last_irrigation_air_humidity = lastIrrigationAirHumidity;
      this.last_irrigation_soil_moisture = lastIrrigationSoilMoisture;
      this.last_irrigation_start = lastIrrigationStart;
    }

    return this;
  }
}
