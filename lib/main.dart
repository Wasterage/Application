import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasterage/driverHome.dart';
import 'package:wasterage/home.dart';
import 'package:wasterage/login.dart';
import 'package:wasterage/userType.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wasterage(),
    );
  }
}

class Wasterage extends StatefulWidget {
  @override
  _WasterageState createState() => _WasterageState();
}

class _WasterageState extends State<Wasterage> {
  bool login = false, citizen = false;

  void initState() {
    super.initState();
    init();
  }

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("email")) {
      setState(() {
        login = true;        
      });
    }
    citizen = preferences.getString("Role") == "Citizen";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body:  login ? (citizen ? Home() : DriverHome()) : UserType(),
      ),
    );
  }
}