import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:wasterage/Models/user.dart';
import 'package:wasterage/Services/api.dart';
import 'package:wasterage/const.dart';
import 'package:wasterage/driverHome.dart';
import 'package:wasterage/home.dart';
import 'package:wasterage/userInfo.dart';

class Login extends StatefulWidget {
  final String role;

  Login({this.role});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  User user = new User();
  bool newUser = false;
  String email;

  @override
  void initState() {
    super.initState();
    setState(() {
      user.role = widget.role;      
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Wasterage',
       emailValidator: (value) {
        if (!value.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        setState(() {
          user.email = loginData.name;
          user.password = loginData.password;          
        });
        return login(user);
      },
      onSignup: (loginData) {
        setState(() {
          user.email = loginData.name;
          user.password = loginData.password;        
        });
        navigateToPush(context, UserInfo(user: user));
        return;
      },
      loginAfterSignUp: true,
      onSubmitAnimationCompleted: () {
        navigateToPush(context, widget.role == "Citizen" ? Home() : DriverHome()); 
      },
      hideForgotPasswordButton: true,
      onRecoverPassword: null,
    );
  }
}