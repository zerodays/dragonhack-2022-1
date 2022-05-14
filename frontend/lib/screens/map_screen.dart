import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/screens/restaurant_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/maps.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<Restaurant>> restaurants;
  String? search;

  @override
  void initState() {
    super.initState();
    restaurants = fetchRestaurants(search);
  }

  void _clearTextField() {
    // Clear everything in the text field
    _controller.clear();
    // Call setState to update the UI
    updateSearch(null);
  }

  void updateSearch(String? val) {
    setState(() {
      if (val == '') {
        search = null;
      } else {
        search = val;
      }

      restaurants = fetchRestaurants(search);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Stack(children: [
              FutureBuilder(
                  future: restaurants,
                  builder: (context, AsyncSnapshot<List<Restaurant>> snapshot) {
                    if (snapshot.hasData) {
                      // Get markers
                      var markers = snapshot.data!
                          .map((e) => Marker(
                              markerId: MarkerId(e.name),
                              position: LatLng(e.latitude, e.longitude),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantScreen(restaurant: e)),
                                );
                              }))
                          .toSet();
                      return Maps(markers: markers);
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text("Failed to load restaurants"));
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 0.0,
                        )),
                    labelText: "Search",
                    suffixIcon: _controller.text.isEmpty
                        ? null // Show nothing if the text field is empty
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearTextField,
                          ), // Show the clear button if the text field has something
                  ),
                  onSubmitted: updateSearch,
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
