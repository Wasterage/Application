import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasterage/Models/bin.dart';
import 'package:wasterage/Models/user.dart';
import 'package:wasterage/const.dart';

getAllBins() async {
  Uri url = Uri.parse(server + "/Bin");
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

addBin(Bin bin) async {
  print(jsonEncode(bin.toJson()));
  Uri url = Uri.parse(server + "/Bin");
  Response response = await post(
    url,
    headers: {
      "accept": "*/*",
      'Content-Type': "application/json"
    },
    body: jsonEncode(bin.toJson())
  );
  print(response.body);
  return response.body;
}

createUser(User user) async {
  String endPoint = server;
  if(user.role == "Driver") {
    endPoint += "/Driver";
  } else {
    endPoint += "/Citizen";
  }
  Uri url = Uri.parse(endPoint);
  Response response = await post(
    url,
    headers: {
      "accept": "*/*",
      'Content-Type': "application/json"
    },
    body: jsonEncode(user.toJson())
  );
  setUser(user.email);
  print(response.body);
  return response.body;
}

Future<String> login(User user) async {
  String endPoint = server;
  if(user.role == "Driver") {
    endPoint += "/Driver";
  } else {
    endPoint += "/Citizen";
  }
  endPoint += ("/"+user.email);
  endPoint += ("/"+user.password);
  Uri url = Uri.parse(endPoint);
  Response response = await get(
    url,
    headers: {"Accept": "application/json", "Connection": "Keep-Alive"},
  );
  dynamic data = json.decode(response.body);
  if(data["exists"] == 1) {
    if(data["valid"] == true) {
      setUser(user.email);
      return "";
    }
    else if(data["valid"] == false) {
      return "Please check your credentials";
    }
  }
  return "Account does not exists";
}

setUser(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("email", email);
}