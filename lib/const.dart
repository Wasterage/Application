import 'package:flutter/material.dart';

void navigateToPush(BuildContext context, Widget destination) {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => destination));
}

const mapBoxKey = "";