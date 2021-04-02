import 'dart:convert';
import 'package:http/http.dart';
import 'package:wasterage/Models/bin.dart';
import 'package:wasterage/const.dart';

getAllBins() async {
  Uri url = Uri.parse("http://13.90.116.39:8080/Bin");
  Response response = await get(
    url,
    headers: {"Accept": "application/json", "Connection": "Keep-Alive"},
  );
  dynamic data = json.decode(response.body);
  List<Bin> ret = [];
  for (int i = 0; i < data.length; i++) {
    Bin bin = Bin.fromJson(data[i]);
    ret.add(bin);
  }
  return ret;
}