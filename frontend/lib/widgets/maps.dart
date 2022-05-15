import 'package:flutter/material.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/screens/restaurant_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NativeMaps extends StatefulWidget {
  final List<Restaurant> markers;

  const NativeMaps({Key? key, required this.markers}) : super(key: key);

  @override
  State<NativeMaps> createState() => _NativeMapsState();
}

class _NativeMapsState extends State<NativeMaps> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(46.0553684, 14.4822385);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 15.0,
      ),
      markers: widget.markers
          .map((m) => Marker(
              markerId: MarkerId(m.name),
              position: LatLng(m.latitude, m.longitude),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantScreen(restaurant: m)));
              }))
          .toSet(),
    );
  }
}
