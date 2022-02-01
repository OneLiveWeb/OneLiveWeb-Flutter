import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olw_mobile_core/olw_mobile_core.dart';
import 'package:oneliveweb/GeoLocation.dart';
import 'package:oneliveweb/SignalK/SignalKManager.dart';






void main() {
  setupBeans();
  runApp(OneLiveWidget());
  var olw = Get.find<OneLiveWeb>();
  olw.initialize();




}

void setupBeans() {
  Get.put<OneLiveWeb>(OneLiveWeb());
  Get.put<GeoLocationManager>(GeoLocationManager());
  Get.put<SignalKManager>(SignalKManager());

}

class OneLiveWidget extends StatelessWidget {
  // This widget is the root of your application.
  var olw = Get.find<OneLiveWeb>();
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${olw.settings?["appname"]}',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: OneLiveWebHome(title: 'One Live Web Events'),
    );
  }
}

class OneLiveWebHome extends StatefulWidget {
  OneLiveWebHome({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _OneLiveWebHomeState createState() => _OneLiveWebHomeState();
}

class _OneLiveWebHomeState extends State<OneLiveWebHome> {
  int _counter = 0;
  var olw = Get.find<OneLiveWeb>();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('${olw.settings?["appname"]}'),
      ),
      body: Container(
        child: GPSWidget(),
      ),
    );
  }
}

class GPSWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GPSWidgetState();
  }
}

class GPSWidgetState extends State<GPSWidget> {
  Position? p;
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: MaterialButton(
                onPressed: updateLocation,
                child: Text(
                  (() {
                    if (p == null) {
                      return "Click to update position";
                    } else {
                      return "Last position was ${p.toString()}. Click to update ";
                    }
                  }()),
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            Flexible(
                child: MaterialButton(
                    onPressed: () {
                      pickImage();
                      print("IMage picked ${image}" );
                    },
                    child: Text("Pick an Image")))
          ],
        ),
      ),
    );
  }

  void updateLocation() async {
    var location = Get.find<GeoLocationManager>();
    p = await location.determinePosition();
    var signalk = Get.find<SignalKManager>();
    if(p!.latitude != null && p!.longitude != null) {
      signalk.sendLocationInformation(p!.latitude, p!.longitude);
    }

    setState(() {});
  }

  String getText() {
    if (p == null) {
      return "Click to update position";
    } else {
      return "Last position was ${p.toString()}. Click to update ";
    }
  }

  pickImage() async {
    ImagePicker picker = ImagePicker();
   image = await picker.pickImage(source: ImageSource.camera);
    print("IMage picked ${image}" );
    image = await picker.pickVideo(source: ImageSource.camera);
    print("IMage picked ${image}" );

  }
}
