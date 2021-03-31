import 'package:flutter/material.dart';
import 'package:wasterage/Models/user.dart';
import 'package:wasterage/Services/auth.dart';
import 'package:wasterage/const.dart';
import 'package:wasterage/home.dart';

class UserInfo extends StatefulWidget {
  String email;

  UserInfo({this.email});
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  UserCust usr = new UserCust();
  Auth auth = new Auth();

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
                    inputField("Role", Icon(Icons.work)),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      onPressed: () async {
                        setState(() {
                          usr.email = widget.email;                          
                        });
                        await auth.setUserInfo(usr);
                        navigateToPush(context, Home());
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
            usr.name = value;
          } else if(title == "Phone") {
            usr.phone = value;
          } else if(title == "Role") {
            usr.role = value;
          }
        },
      )
    );
  }
}