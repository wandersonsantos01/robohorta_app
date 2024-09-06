import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<bool> irrigate() async {
  var res = true;
  try {
    var headers = {
      'tk': dotenv.env['api_token']!
    };

    var url = dotenv.env['api_url']! + dotenv.env['api_p_irrigate_uri']!;
    var requestIrrigate = http.Request('POST', Uri.parse(url));

    requestIrrigate.headers.addAll(headers);

    http.StreamedResponse responseIrrigate = await requestIrrigate
        .send();

    if (responseIrrigate.statusCode == 200) {
      var lastReadingResponse = await responseIrrigate.stream
          .bytesToString();
    }
    else {
      res = false;
      print(responseIrrigate.reasonPhrase);
    }

  } on SocketException {
    // print('SocketException');
    res = false;
  } on Error catch (e) {
    // print('Error: $e');
    res = false;
  }
  return res;
}
