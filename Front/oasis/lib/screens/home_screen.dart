import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oasis/services/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Post>> getData({double latitude, double longitude}) async {
  final response =
      await http.get("localhost:8080/api/oasis/trashcans?lon=$longitude&lat=$latitude");
  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    var postList = data.map((element) => Post.fromJson(element)).toList();
    return postList;
  } else {
    print(response.statusCode);
  }
}

class Post {
  final String address;
  final String location;
  final String trashType;
  final int distance;
  final int id;
  final double latitude;
  final double longitude;

  Post({
    this.address,
    this.location,
    this.trashType,
    this.distance,
    this.id,
    this.latitude,
    this.longitude,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      address: json['address'],
      location: json['location'],
      trashType: json['trashType'],
      distance: json['distance'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Post>> postList;
  double latitude;
  double longitude;
  GoogleMapController _controller;
  Widget _child;

  void getUserLocation() async {
    Location location = Location();
    var position = await location.getCurrentLocation();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      postList = getData(latitude: latitude,longitude: longitude);
      print(postList);
      DestinationMarkers.add(
        Marker(
          markerId: MarkerId('TrashCan1'),
          draggable: false,
          position: LatLng(
            latitude,
            longitude,
          ),
        ),
      );
      _child = mapWidget();
    });
  }

  Widget mapWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set.from(DestinationMarkers),
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 17,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }

  List<Marker> DestinationMarkers = [];

  @override
  void initState() {
    // TODO: implement initState
    getUserLocation();
    super.initState();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    DestinationMarkers.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.person_outline_outlined,
                      size: 30,
                    ),
                    onPressed: null,
                  ),
                  Center(
                    child: Text(
                      'Oasis',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello Eco-Friend!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Luke',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: _child,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: Material(
                  elevation: 5.0,
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10.0),
                  child: MaterialButton(
                    onPressed: () {},
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Add Trash Can',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
