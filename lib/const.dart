import 'package:flutter/material.dart';

void navigateToPush(BuildContext context, Widget destination) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => destination));
}

const mapBoxKey = "";
String server = "http://13.90.116.39:8080";

void navigateTo(BuildContext context, Widget destination) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
}