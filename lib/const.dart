import 'package:flutter/material.dart';

void navigateToPush(BuildContext context, Widget destination) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => destination));
}

String server = "http://52.152.238.50:8080";

void navigateTo(BuildContext context, Widget destination) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
}