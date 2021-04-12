import 'package:flutter/material.dart';
import 'package:wasterage/Models/user.dart';
import 'package:wasterage/Services/api.dart';
import 'package:wasterage/const.dart';
import 'package:wasterage/driverHome.dart';
import 'package:wasterage/home.dart';

class UserInfo extends StatefulWidget {
  final User user;

  UserInfo({this.user});
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  User user;

  @override
  void initState() {
    super.initState();
    setState(() {
      user = widget.user;      
    });
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
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    inputField("Name", Icon(Icons.person)),
                    inputField("Phone", Icon(Icons.phone)),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      onPressed: () async {
                        await createUser(user);
                        navigateToPush(context, user.role == "Citizen" ? Home() : DriverHome());
                      }, 
                      child: Text("Next", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
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

  Widget inputField(String title, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(100),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(100),
          ),
          fillColor: Color.alphaBlend(
            Colors.blue.withOpacity(.07),
            Colors.grey.withOpacity(.04),
          ),
          labelStyle: TextStyle(fontSize: 18),
          prefixIcon: icon,
          filled: true,
          labelText: title
        ),
        onChanged: (value) {
          if(title == "Name") {
            user.name = value;
          } else if(title == "Phone") {
            user.phone = value;
          } 
        },
      )
    );
  }
}