import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:wasterage/Models/bin.dart';
import 'package:wasterage/Services/api.dart';
import 'package:wasterage/const.dart';
import 'package:location/location.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  MapboxMapController mapController;
  LatLng myPos;
  bool loading = true;
  List<Bin> bins;

  void initState() {
    super.initState();
    init();
  }

  init() async {
    LatLng temp = await acquireCurrentLocation();
    List<Bin> curr = await getAllBins();
    setState(() {
      myPos = temp; 
      bins = curr;
      loading = false;
    });
  }

  Future<LatLng> acquireCurrentLocation() async {
    Location location = new Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    final locationData = await location.getLocation();
    return LatLng(locationData.latitude, locationData.longitude);
  }


  void _onMapCreated(MapboxMapController controller) {
    setState(() {
      mapController = controller;      
    });
    for(Bin bin in bins) {
      mapController.addSymbol(
        SymbolOptions(
          geometry: bin.cord,
          iconImage: "cemetery-15",
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Center(
      child: SpinKitDoubleBounce(size: 20,
      color: Colors.red,),
    ) : Scaffold(
      body: MapboxMap(
        accessToken: mapBoxKey,
        onMapCreated: _onMapCreated,
        initialCameraPosition: new CameraPosition(
          target: myPos,
          zoom: 11.0,
        ),
      ),
    );
  }
}