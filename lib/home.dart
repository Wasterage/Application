import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wasterage/Models/bin.dart';
import 'package:wasterage/Services/api.dart';
import 'package:wasterage/addBin.dart';
import 'package:wasterage/const.dart';
import 'package:wasterage/userType.dart';
import 'package:wasterage/utility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';

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
  Set<Polyline> _polyline = {};
  List<LatLng> cor = [];

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
    await readJson();
    _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        //latlng is List<LatLng>
        points: cor,
        width: 2,
        color: Colors.blue,
      ));
    setState(() {
      loading = false;      
    });
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/coordinates.json');
    dynamic data = await json.decode(response)["coordinates"];
    for(int i=0;i<data.length;i++) {
      cor.add(new LatLng(data[i]["latitude"], data[i]["longitude"]));
    }
    print(cor);
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
              height: 0.60 * MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      navigateTo(context, AddBin());
                    }, 
                    label: Text("Add Bin"),
                    icon: Icon(Icons.add_circle),
                    backgroundColor: Colors.green,
                  ),
                ],
              )
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Do you really want to logout?"),
                      actions: [
                        TextButton(
                          child: Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text("Yes"),
                          onPressed: () async {
                            await setUser("");
                            navigateToPush(context, UserType());
                          },
                        )
                      ],
                    );
                  }
                );
              }, 
              label: Text("Logout", style: TextStyle(fontSize: 16, color: Colors.black)),
              icon: Icon(Icons.exit_to_app, size: 40, color: Colors.black,),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("v1.0 Made with ❤️ by Ozone",
                style: TextStyle(
                  color: Colors.grey
                ),
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
        polylines: _polyline,
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