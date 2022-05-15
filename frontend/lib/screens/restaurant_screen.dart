import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/models/allergens.dart';
import 'package:frontend/models/restaurant.dart';
import 'package:frontend/widgets/current_allergens.dart';
import 'package:frontend/widgets/menu_card.dart';
import 'package:provider/provider.dart';

import '../models/menu.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key, required this.restaurant})
      : super(key: key);

  final Restaurant restaurant;

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen>
    with TickerProviderStateMixin {
  late Future<List<Menu>> menu;

  @override
  void initState() {
    super.initState();
    menu = fetchMenu(widget.restaurant.restaurantId,
        Provider.of<Allergens>(context, listen: false).userAllergens);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.restaurant.name),
        ),
        body: Row(
          children: [
            Expanded(
                child: Card(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                widget.restaurant.rating != null
                    ? ListTile(
                        leading: const Icon(Icons.star),
                        title: Text("Rating: ${widget.restaurant.rating}"),
                        minLeadingWidth: 10,
                      )
                    : const SizedBox(),
                ListTile(
                  leading: const Icon(Icons.house),
                  title: Text(
                      "Address: ${widget.restaurant.address?.streetAddress}"),
                  minLeadingWidth: 10,
                ),
                const CurrentAllergens(),
                Expanded(
                    child: FutureBuilder(
                        future: menu,
                        builder: (context, AsyncSnapshot<List<Menu>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var menuData = snapshot.data![index];
                                return MenuCard(menuData: menuData);
                              },
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text("Failed to load menu."));
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }))
              ],
            )))
          ],
        ));
  }
}
