import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class SignalKManager {
  void sendLocationInformation(double? lat, double? long) async {
    final channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.8.142:3000/signalk/v1/stream'));

    printServerMessages(channel.stream);
    Map testmap = {
      "context": "vessels.self",
      "updates": [
        {
          "values": [
            {
              "path": "navigation.position",
              "value": {"altitude": 0, "latitude": lat, "longitude": long}
            }
          ]
        }
      ]
    };
    print(jsonEncode(testmap));

    channel.sink.add(jsonEncode(testmap));
  }

  Future<dynamic> printServerMessages(Stream<dynamic> stream) async {
    await for (var value in stream) {
      print(value);
    }
  }
}
