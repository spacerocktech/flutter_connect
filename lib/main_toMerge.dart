import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'dart:developer';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          body: FireMap()
      )
    );
  }
}

class FireMap extends StatefulWidget {
  @override
  State createState() => FireMapState();
}

class FireMapState extends State<FireMap> {

  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();

  Location location = new Location();

  final Set<Marker> _markers = Set();

  // Stateful Data
  BehaviorSubject<double> radius = BehaviorSubject<double>();
  
  Stream<dynamic> query;
  // Subscription
  StreamSubscription subscription;

  build(context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
          mapType: MapType.normal,
          markers: _markers,
        ),
        Positioned(
          bottom: 50,
          right: 100,
          child: 
            FlatButton(
              child: Icon(Icons.pin_drop),
              color: Colors.green,
              onPressed: () => _addGeoPoint()
              )
        )
      ]
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      //set initial state here
    });
  }

  _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint myLocation = geo.point(latitude: pos.latitude, longitude: pos.longitude);

    _firestore
      .collection('locations')
      .add({
        'name': 'Test Name',
        'location': 'Boulder, CO',
        'bio': 'Sample Biography.',
        'fb_url': 'https://www.facebook.com',
        'gh_url': 'https://www.github.com', 
        'position': myLocation.data 
      }); 

      Marker resultMarker = Marker(
          markerId: MarkerId(myLocation.toString()),
          position:  LatLng(pos.latitude, pos.longitude),
          infoWindow: InfoWindow(
            title: 'Max Nachamkin',
            snippet: 'Spacerock',
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        log('make it?');

      _markers.add(resultMarker);

    
  }
}


