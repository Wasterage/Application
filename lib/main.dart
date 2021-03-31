import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasterage/home.dart';
import 'package:wasterage/login.dart';
import 'package:wasterage/userInfo.dart';

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
  bool loading = true, login = false;

  void initState() {
    super.initState();
    init();
    Firebase.initializeApp().whenComplete(() {
      setState(() {
        loading = false;
      });
    });
  }

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey("email")) {
      setState(() {
        login = true;        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: loading ? Center(
            child: SpinKitWanderingCubes(
            color: Colors.red,
            size: 20,
          )
        ) : login ? Home() : Login(),
      ),
    );
  }
}