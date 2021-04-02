import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:wasterage/Models/bin.dart';
import 'package:wasterage/Services/api.dart';
import 'package:wasterage/addBin.dart';
import 'package:wasterage/const.dart';
import 'package:wasterage/utility.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  MapboxMapController mapController;
  LatLng myPos;
  bool loading = true;
  List<Bin> bins;
  double w,h;

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

  void _onMapCreated(MapboxMapController controller) {
    setState(() {
      mapController = controller;      
    });
    for(Bin bin in bins) {
      mapController.addSymbol(
        SymbolOptions(
          geometry: bin.cord,
          iconImage: "cemetery-15",
          iconSize: 2
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    return loading ? Center(
      child: SpinKitWave(
          color: Colors.blue,
          size: 30,
        )
      ) : Scaffold(
      appBar: AppBar(
        title: Text(
          "Wasterage",
          style: TextStyle(
            color: Colors.blue
          ),
        ),
        iconTheme: IconThemeData(color: Colors.blue),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 0.05 * h),
              height: 0.20 * h,
              child: Image.asset("assets/images/logo.png"),
            ),
            Container(
              height: 0.7 * MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle, size: 30),
                        Text(" Add Bin",
                          style: TextStyle(
                            fontSize: 18
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      navigateTo(context, AddBin());
                    },
                  )
                ],
              )
            )
          ],
        ),
      ),
      body: MapboxMap(
        accessToken: mapBoxKey,
        onMapCreated: _onMapCreated,
        initialCameraPosition: new CameraPosition(
          target: myPos,
          zoom: 15.0,
        ),
      ),
    );
  }
}