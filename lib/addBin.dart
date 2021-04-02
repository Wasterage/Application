import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:wasterage/Models/bin.dart';
import 'package:wasterage/Services/api.dart';
import 'package:wasterage/utility.dart';

class AddBin extends StatefulWidget {
  @override
  _AddBinState createState() => _AddBinState();
}

class _AddBinState extends State<AddBin> {

  Bin bin = new Bin();
  double lat, lng;
  TextEditingController t1 = new TextEditingController();
  TextEditingController t2 = new TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      t1.text = "";
      t2.text = "";      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 40),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: loading ? SpinKitWave(
          color: Colors.white,
          size: 30,
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 0.15 * MediaQuery.of(context).size.height,
            ),
            Text(
              "Add Bin",
              style: TextStyle(
                color: Colors.white,
                fontSize: 35
              ),
            ),
            Card(
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 0.35 * MediaQuery.of(context).size.width,
                          child: inputField("Lat", Icon(Icons.location_on)),
                        ),
                        Container(
                          width: 0.35 * MediaQuery.of(context).size.width,
                          child: inputField("Lng", Icon(Icons.location_on)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("OR"),
                    ),
                    GestureDetector(
                      child: Icon(Icons.my_location, size: 50),
                      onTap: () async {
                        setState(() {
                          loading = true;                          
                        });
                        bin.cord = await acquireCurrentLocation();
                        setState(() {
                          t1 = new TextEditingController(text: bin.cord.latitude.toString());
                          t2 = new TextEditingController(text: bin.cord.longitude.toString());      
                          loading = false;                    
                        });
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      onPressed: () async {
                        setState(() {
                          loading = true;
                          if(bin.cord == null)
                            bin.cord = new LatLng(lat, lng);                          
                        });
                        String res = await addBin(bin);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Bin added successfully with id $res"),
                              actions: [
                                TextButton(
                                  child: Text("Ok"),
                                  onPressed: () {
                                    setState(() {
                                      loading = false;              
                                    });
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }
                        );
                      }, 
                      child: Text("Add", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        )
                      ),
                      elevation: 5,
                    )
                  ],
                ),
              )
            )
          ],
        )
      )
    );
  }

  Widget inputField(String title, Icon icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(100),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(100),
          ),
          fillColor: Color.alphaBlend(
            Colors.blue.withOpacity(.07),
            Colors.grey.withOpacity(.04),
          ),
          labelStyle: TextStyle(fontSize: 18),
          prefixIcon: icon,
          filled: true,
          labelText: title,
        ),
        keyboardType: TextInputType.number,
        controller: title == "Lat" ? t1 : t2,
        onChanged: (value) {
          if(title == "Lat") {
            lat = double.parse(value);
          } else {
            lng = double.parse(value);
          }
        },
      )
    );
  }
}