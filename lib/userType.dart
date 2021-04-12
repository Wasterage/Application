import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasterage/const.dart';
import 'package:wasterage/login.dart';

class UserType extends StatefulWidget {
  @override
  _UserTypeState createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {

  @override
  void initState() {
    super.initState();
    init();
  }

  SharedPreferences preferences;

  init() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      color: Colors.blue,
                      onPressed: () async {
                        await preferences.setString("Role", "Driver");
                        navigateToPush(context, Login(role: "Driver",));
                      }, 
                      child: Text("Driver", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24
                        )
                      ),
                      elevation: 5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                      color: Colors.blue,
                      onPressed: () async {
                        await preferences.setString("Role", "Citizen");
                        navigateToPush(context, Login(role: "Citizen",));
                      }, 
                      child: Text("Citizen", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24
                        )
                      ),
                      elevation: 5,
                    )
                  ],
                ),
              )
            )
          ],
        )
      )
    );
  }
}