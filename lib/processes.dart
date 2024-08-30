import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

irrigate() async {
  var res = true;
  var headers = {
    'token': dotenv.env['rh_token']!
  };

  // LAST READING
  var url = dotenv.env['rh_url']! + ":" + dotenv.env['rh_port']! + dotenv.env['rh_irrigate_uri']!;
  var requestIrrigate = http.Request('POST', Uri.parse(url));

  requestIrrigate.headers.addAll(headers);

  http.StreamedResponse responseLastReading = await requestIrrigate
      .send();

  if (responseLastReading.statusCode == 200) {
    var lastReadingResponse = await responseLastReading.stream
        .bytesToString();
  }
  else {
    res = false;
    print(responseLastReading.reasonPhrase);
  }

  return res;
}
