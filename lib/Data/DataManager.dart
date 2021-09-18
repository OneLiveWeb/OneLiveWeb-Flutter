import 'package:xml/xml.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class DataManager{
  PropertyDetailsArchive archive = PropertyDetailsArchive();



}
class PropertyDetailsArchive {

  Future<List<PropertyDetail>>  loadPropertyDetails(String inSearchType) async{
    String xml = await rootBundle.loadString("system/fields/${inSearchType}.xml");
    final document = XmlDocument.parse(xml);
    List<PropertyDetail> details = [];
    document.getElement("properties")!.childElements.forEach((detailxml) {
      PropertyDetail detail = PropertyDetail();
      detail.id = detailxml.getAttribute("id");
      detail.viewtype = detailxml.getAttribute("viewtype") ?? "default";
      detail.name = detailxml.getAttribute("name") ?? detailxml.text ;
      detail.editable = detailxml.getAttribute("editable")!.toLowerCase() == 'true';
      details.add(detail);
      print("Details are ${detail}");
    });
    print(details);
    return details;

  }



}
//https://stackoverflow.com/questions/55169565/create-class-instance-from-string-in-dartlang - we'll need this to create names widgets from the config files
// MirrorSystem mirrors = currentMirrorSystem();
// ClassMirror classMirror = mirrors.findLibrary(Symbol.empty).declarations[new Symbol('Opacity')];
// print(classMirror);
// var arguments = {'a': 'a', 'b': 'b', 'c': 'c'}.map((key, value) {
//   return MapEntry(Symbol(key), value);
// });
// var op = classMirror.newInstance(Symbol.empty, [], arguments);
// Opacity opacity = op.reflectee;
// print("opacity.a: ${opacity.a}");
// print("opacity.b: ${opacity.b}");
// print("opacity.c: ${opacity.c}");


class PropertyDetail  {

  String viewtype = "default";
  String name ="default";
  String? id;
  bool editable = true;
  @override
  String toString() {
    // TODO: implement toString
    return "${name}";
  }

}