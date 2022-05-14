import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key, this.markers}) : super(key: key);

  final Set<Marker>? markers;

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(46.0553684, 14.4822385);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final marker = const Marker(
    markerId: MarkerId('place_name'),
    position: LatLng(9.669111, 80.014007),
    // icon: BitmapDescriptor.,
    infoWindow: InfoWindow(
      title: 'title',
      snippet: 'address',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 15.0,
      ),
      markers: widget.markers ?? {},
    );
  }
}
