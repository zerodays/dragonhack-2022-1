import 'package:flutter/material.dart';

import 'package:frontend/api/api.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/screens/restaurant_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Restaurant>> restaurants;

  @override
  void initState() {
    super.initState();
    restaurants = fetchRestaurants(null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: restaurants,
      builder: (context, AsyncSnapshot<List<Restaurant>> snapshot) {
        if (snapshot.hasData) {
          return _RestaurantList(restaurants: snapshot.data!);
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
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (BuildContext context, int index) {
        return _RestaurantListCard(restaurant: restaurants[index]);
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
      child: ListTile(
        isThreeLine: true,
        leading: CircleAvatar(
            backgroundImage: restaurant.imageURL != null
                ? NetworkImage(restaurant.imageURL!)
                : null),
        title: Text(restaurant.name),
        subtitle: Text(restaurant.description ?? ''),
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
