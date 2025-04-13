import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled1/screens/add_post.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});

  @override
  State<GoogleMapFlutter> createState() => _GoogleMapFlutterState();
}

class _GoogleMapFlutterState extends State<GoogleMapFlutter> {
  LatLng myCurrentPosition = const LatLng(49.203568, -122.912689);
  late GoogleMapController mapController;
  late Marker selectedMarker = Marker(
      markerId: MarkerId('Selected Location'), position: myCurrentPosition);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FloatingActionButton(
            onPressed: () async {
              Position myLocation = await getCurrentLocation();
              selectLocation(LatLng(myLocation.latitude, myLocation.longitude));
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      zoom: 14,
                      target: LatLng(myLocation.latitude, myLocation.longitude))));
              // Navigator.pop(context, myCurrentPosition);
            },
            child: Icon(Icons.my_location),
          ),
          FloatingActionButton(
            onPressed: () async {
              Navigator.pop(context, myCurrentPosition);
            },
            child: Icon(Icons.navigate_next),
          ),
        ],
      ),

      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: myCurrentPosition, zoom: 15),
        onMapCreated: (controller) {
          mapController = controller;
          // addMarker('Current Location', myCurrentPosition);
        },
        markers: {selectedMarker},
        onTap: (latin) {
          selectLocation(latin);
        },
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
      ),
    );
  }

  selectLocation(LatLng position) async {
    // var marker = Marker(markerId: MarkerId(markerName), position: position);
    // _markers.putIfAbsent(markerName, () => marker);
    myCurrentPosition = position;
    selectedMarker =
        Marker(markerId: MarkerId('Selected Location'), position: position);
    setState(() {});
  }

  Future<Position> getCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }
}
