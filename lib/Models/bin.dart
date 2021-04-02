import 'package:mapbox_gl/mapbox_gl.dart';

class Bin{
  int id;
  LatLng cord;
  bool filled;

  Bin({this.id, this.cord, this.filled});

  Bin.fromJson(Map<String, dynamic> json) {
    id = json["Bin_ID"];
    cord = LatLng(json["latitude"], json["longitude"]);
    filled = json["level"] == 1 ? true : false;
  }
}