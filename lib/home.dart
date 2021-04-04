import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wasterage/Models/bin.dart';
import 'package:wasterage/Services/api.dart';
import 'package:wasterage/addBin.dart';
import 'package:wasterage/const.dart';
import 'package:wasterage/utility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  LatLng myPos;
  bool loading = true;
  double w,h;
  Set<Marker> markers = new Set();

  void initState() {
    super.initState();
    init();
  }

  init() async {
    LatLng temp = await acquireCurrentLocation();
    List<Bin> curr = await getAllBins();
    setState(() {
      myPos = temp; 
    });
    for(Bin bin in curr) {
      Marker m = new Marker(
        markerId: MarkerId(bin.id.toString()), 
        position: bin.cord,
        onTap: () {
          print(bin.id);
        },
        icon: await BitmapDescriptor.fromAssetImage(createLocalImageConfiguration(context), 'assets/images/marker.png')
      );
      markers.add(m);
    }
    setState(() {
      loading = false;      
    });
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
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: new CameraPosition(
          target: myPos,
          zoom: 15
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLake,
        child: Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: await acquireCurrentLocation(), zoom: 15)));
  }
}