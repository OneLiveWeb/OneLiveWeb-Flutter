import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:olw_mobile_core/Data/DataManager.dart';
import 'package:oneliveweb/GeoLocation.dart';
import 'package:oneliveweb/SignalK/SignalKManager.dart';
import 'package:oneliveweb/main.dart';

class OneLiveWebOld {
  String _bob = "This is my pretty variable";
  String _tom = "";

  String get bob {
    return "Ian was here ${_bob}";
  }

  Future<Map> getJsonFromServer(String inUrl) async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  void printSomething(String s) async {
    var location = Get.find<GeoLocationManager>();
    var signalk = Get.find<SignalKManager>();
    var dataManager = Get.find<DataManager>();
    Map map = await getJsonFromServer(s);
    print(map);
    Position position = await location.determinePosition();
    print("Lat and long was ${position}");
    signalk.sendLocationInformation(position.latitude, position.longitude);
    await dataManager.archive.loadPropertyDetails("asset");
    print("All done");
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Yep this works ";
  }

  saveSomething() {}
}
