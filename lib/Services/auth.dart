import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wasterage/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential userCredential;
  final databaseReference = FirebaseDatabase.instance.reference();


  Future<String> createAccount(LoginData loginData) async {
    print(loginData);
    try {
      userCredential = await auth.createUserWithEmailAndPassword(email: loginData.name, password: loginData.password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', loginData.name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<String> signIn(LoginData loginData) async {
    try {
      userCredential = await auth.signInWithEmailAndPassword(email: loginData.name, password: loginData.password);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', loginData.name);
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  setUserInfo(UserCust usr) async {
    return await FirebaseFirestore.instance.collection(usr.role)
      .doc(FirebaseAuth.instance.currentUser.uid)
      .set({
        'name': usr.name,
        'email': usr.email,
        'phone': usr.phone
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
  }
}