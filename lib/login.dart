import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:wasterage/Services/auth.dart';
import 'package:wasterage/const.dart';
import 'package:wasterage/home.dart';
import 'package:wasterage/userInfo.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  Auth auth = new Auth();
  bool newUser = false;
  String email;

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
        return auth.signIn(loginData);
      },
      onSignup: (loginData) {
        setState(() {
          newUser = true;  
          email = loginData.name;        
        });
        return auth.createAccount(loginData);
      },
      loginAfterSignUp: true,
      onSubmitAnimationCompleted: () {
        newUser ? navigateToPush(context, UserInfo(email: email)): navigateToPush(context, Home()); 
      },
      hideForgotPasswordButton: true,
      onRecoverPassword: null,
    );
  }
}