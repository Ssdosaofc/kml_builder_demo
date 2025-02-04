import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:kml_builder_demo/screens/settings_page.dart';
import 'package:kml_builder_demo/utils/kml_entity.dart';
import 'package:kml_builder_demo/utils/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../services/ssh.dart';
import '../utils/LookAt.dart';

bool connectionStatus = false;

void main() {
  //TODO: Initialize Google Map for Flutter
  // final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
  // if(mapsImplementation is GoogleMapsFlutterAndroid){
  //   mapsImplementation.useAndroidViewSurface = true;
  // }
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Marker prevMarker = Marker(markerId: MarkerId('prevMarker)'));
  Marker marker = Marker(markerId: MarkerId('marker)'));

  List<LatLng> vertices = [];
  Set<Polygon> polygon = {Polygon(polygonId: PolygonId('value'),
      points: []
  )};

  List<LatLng> path = [];
  Set<Polyline> polyline = {Polyline(polylineId: PolylineId('value'),
    points: []
  )};

  TextEditingController descController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String val = 'Marker';

  late Ssh ssh;

  Future<void> _connectToLG() async {
    bool? result = await ssh.connectToLG();
    setState(() {
      connectionStatus = result!;
    });
  }

  @override
  void initState() {
    super.initState();
    ssh = Ssh();
    _connectToLG();

    polygon = {Polygon(polygonId: PolygonId('value'),
        points: vertices,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeColor: Colors.blue,
        strokeWidth: 3
    )};
    polyline = {Polyline(polylineId: PolylineId('value'),
        points: path,
      color: Colors.red,
      width: 3
    )};
  }

  //TODO: Handle onTap functions for each case
  // void _onTapPolyline(LatLng latlng){
  //   setState(() {
  //     path.add(latlng);
  //   });
  //
  // }
  //
  // void _onTapPolygon(LatLng latlng){
  //   setState(() {
  //     vertices.add(latlng);
  //   });
  // }
  //
  // void _onTap(LatLng latlng){
  //   setState(() {
  //     prevMarker = marker;
  //     markers.remove(prevMarker);
  //     marker = Marker(markerId: MarkerId(nameController.text),
  //       position: latlng,
  //       infoWindow: InfoWindow(title: descController.text)
  //     );
  //     markers.add(marker);
  //   });
  // }

  //TODO: Create KML out of LatLng lists using utils
  String createKml(){
  //   Utility utility = Utility();
  //   String kml = '';
  //   switch(val){
  //     case 'Marker':
  //       setState(() {
  //         kml = utility.createMarker(marker);
  //       });
  //     case 'Polygon':
  //       setState(() {
  //         kml = utility.createPolygon(vertices);
  //       });
  //     case 'Polyline':
  //       setState(() {
  //         kml = utility.createPolyline(path);
  //       });
  //   }
  //   return kml;
  // }

  //TODO: Save KML locally
  // void saveKml(BuildContext context) async{
  //   if(nameController.text.isEmpty){
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Name cant be empty'))
  //     );
  //     return;
  //   }
  //
  //   print(createKml());
  //   Directory docDirectory = await getApplicationDocumentsDirectory();
  //   String path = join(docDirectory.path, '${nameController.text}.kml');
  //
  //   KMLEntity kmlEntity = KMLEntity(name: nameController.text, content: createKml(), desc: descController.text);
  //
  //   File file = File(path);
  //   print(kmlEntity.body);
  //   file.writeAsString(kmlEntity.body);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('KML file created successfully in $path'))
  //   );
  // }

  LatLng getCentroid(List<LatLng> points) {
    double latSum = 0, lngSum = 0;
    for (var point in points) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text("Custom KML Builder",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.grey.shade700,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings,color: Colors.white,),
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage())
              );
              _connectToLG();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: (){
                  setState(() {
                    markers.clear();
                    vertices.clear();
                    path.clear();
                    nameController.clear();
                    descController.clear();
                  });
                },
                    child: Row(
                      children: [
                        Icon(Icons.cleaning_services,color: Colors.white,),
                        SizedBox(width: 7,),
                        Text('CLEAR MAP',style: TextStyle(color: Colors.white)),
                      ],
                    )),
                TextButton(onPressed: (){
                  ssh.clearKml();
                }, child:
                Row(
                  children: [
                    Icon(Icons.clear,color: Colors.white),
                    SizedBox(width: 7,),
                    Text('CLEAR KML',style: TextStyle(color: Colors.white),),
                  ],
                )
                )
              ],
            ),
            SizedBox(height: 8,),
            //TODO: Create Google Map
            // Expanded(
            //     child: Stack(
            //       alignment: Alignment.topRight,
            //       children: <Widget>[ClipRRect(
            //         borderRadius: BorderRadius.all(Radius.circular(10)),
            //         child: GoogleMap(
            //           markers: (val == 'Marker')?markers:{},
            //           polygons: (val == 'Polygon' && vertices.length>2)
            //               ?polygon:{},
            //           polylines: (val == 'Polyline')?polyline:{},
            //             initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
            //           onTap: (latlng){
            //             switch(val){
            //             case 'Marker': _onTap(latlng);
            //             case 'Polygon': _onTapPolygon(latlng);
            //             case 'Polyline': _onTapPolyline(latlng);
            //             }
            //           },
            //         ),
            //       ),
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Container(
            //             padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 11.0),
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.all(Radius.circular(10)),
            //                 boxShadow: [BoxShadow(blurRadius: 9,spreadRadius: 0.3)]
            //             ),
            //             child: DropdownButton(
            //                 icon: Icon(Icons.arrow_drop_down_outlined),
            //                 value: val,
            //                 items: const [
            //                   DropdownMenuItem<String>(
            //                     value: 'Marker',
            //                     child: Text("Marker"),
            //                   ),
            //                   DropdownMenuItem<String>(
            //                     value: 'Polygon',
            //                     child: Text("Polygon"),
            //                   ),
            //                   DropdownMenuItem<String>(
            //                     value: 'Polyline',
            //                     child: Text("Polyline"),
            //                   ),
            //                 ],
            //                 onChanged: (nval){
            //                   setState(() {
            //                     val = nval!;
            //                   });
            //                 }),
            //           ),
            //         ),
            //       ],
            //     )
            // ),
            SizedBox(height: 15,),
            Column(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [BoxShadow(blurRadius: 3,color:Colors.white)]
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7.0,horizontal: 15),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: "Name",
                          hintText: "Add name",
                          labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black)
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [BoxShadow(blurRadius: 3,color:Colors.white)]
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7.0,horizontal: 15),
                    child: TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: "Description",
                        hintText: "Add description",
                        labelStyle: TextStyle(color: Colors.black),
                        hintStyle: TextStyle(color: Colors.black)
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: () async{
                    //TODO: Send KML to LG
                    // late LookAt lookAt;
                    //
                    // switch(val){
                    //   case 'Marker':
                    //     setState(() {
                    //       lookAt = LookAt(marker.position.longitude, marker.position.latitude,
                    //         1000.0, "500", "45", "0",
                    //       );
                    //     });
                    //     break;
                    //
                    //   case 'Polygon':
                    //     setState(() {
                    //       if (vertices.isNotEmpty) {
                    //         LatLng center = getCentroid(vertices);
                    //         lookAt = LookAt(
                    //           center.longitude, center.latitude,
                    //           1000.0, "1000", "30", "0",
                    //         );
                    //       }
                    //     });
                    //     break;
                    //
                    //   case 'Polyline':
                    //     setState(() {
                    //       if (path.isNotEmpty) {
                    //         LatLng center = getCentroid(path);
                    //         lookAt = LookAt(
                    //           center.longitude, center.latitude,
                    //           1000.0, "1500", "20", "0",
                    //         );
                    //       }
                    //     });
                    //     break;
                    // }
                    // await ssh.sendKml(createKml(), nameController.text, descController.text, lookAt);
                  },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return Colors.white;
                      },
                    ),
                      elevation: WidgetStateProperty.all(7.0)
                  ), child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined,color: Colors.red),
                      SizedBox(width: 5,),
                      Text('Send to LG',style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: ElevatedButton(onPressed: (){
                    //TODO: Call saveKml function
                    // saveKml(context);
                  },
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return Colors.white;
                      },
                    ),
                        elevation: WidgetStateProperty.all(7.0)
                  ), child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_alt_sharp,color: Colors.purple),
                      SizedBox(width: 5,),
                      Text('Save as KML',style: TextStyle(color: Colors.black),),
                    ],
                  ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}


