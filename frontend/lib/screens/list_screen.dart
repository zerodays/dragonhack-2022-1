import 'package:flutter/material.dart';

import 'package:frontend/api/api.dart';
import 'package:frontend/models/allergens.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/screens/restaurant_screen.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Restaurant>> restaurants;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    restaurants = fetchRestaurants(
        null, Provider.of<Allergens>(context, listen: false).userAllergens);
  }

  void _clearTextField() {
    // Clear everything in the text field
    _controller.clear();
    // Call setState to update the UI
    updateSearch(null);
  }

  void updateSearch(String? val) {
    setState(() {
      restaurants = fetchRestaurants(
          val, Provider.of<Allergens>(context, listen: false).userAllergens);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: restaurants,
      builder: (context, AsyncSnapshot<List<Restaurant>> snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Stack(
              children: [
                _RestaurantList(restaurants: snapshot.data!),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: "Search",
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 0.0),
                      ),
                      suffixIcon: _controller.text.isEmpty
                          ? null // Show nothing if the text field is empty
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearTextField,
                            ), // Show the clear button if the text field has something
                    ),
                    onSubmitted: updateSearch,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Failed to load restaurants"));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _RestaurantList extends StatelessWidget {
  final List<Restaurant> restaurants;

  const _RestaurantList({Key? key, required this.restaurants})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var count = 0;
    var width = MediaQuery.of(context).size.width;
    if (width < 700) {
      count = 2;
    } else if (width < 900) {
      count = 3;
    } else if (width < 1200) {
      count = 4;
    } else {
      count = 5;
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(8, 72, 8, 0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: count,
      ),
      itemCount: restaurants.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: _RestaurantListCard(restaurant: restaurants[index]),
        );
      },
    );
  }
}

class _RestaurantListCard extends StatelessWidget {
  final Restaurant restaurant;

  const _RestaurantListCard({Key? key, required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              restaurant.imageURL != null
                  ? AspectRatio(
                      aspectRatio: 2,
                      child: Image.network(
                        '$apiUrl/cigani_cors/?url=${restaurant.imageURL!}',
                        fit: BoxFit.fill,
                      ),
                    )
                  : const Center(child: Text('No Image')),
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                child: Text(
                  restaurant.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(height: 0.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 4.0),
                child: Text(
                  restaurant.description ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantScreen(restaurant: restaurant),
            ),
          );
        },
      ),
    );
  }
}
