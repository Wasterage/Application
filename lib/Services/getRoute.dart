import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:wasterage/const.dart';

Future<List<LatLng>> getRoute(LatLng latLng) async {
  Uri url = Uri.parse(server + "/Route/"+latLng.latitude.toString()+"/"+latLng.longitude.toString());
  Response response = await get(
    url,
    headers: {"Accept": "application/json", "Connection": "Keep-Alive"},
  );
  dynamic data = await json.decode(response.body)["coordinates"];
  List<LatLng> cor = [];
  for(int i=0;i<data.length;i++) {
    cor.add(new LatLng(data[i]["latitude"], data[i]["longitude"]));
  }
  return cor;
}