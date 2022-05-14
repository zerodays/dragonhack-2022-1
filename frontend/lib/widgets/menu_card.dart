import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../util/constants.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({Key? key, required this.menuData}) : super(key: key);

  final Menu menuData;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        isThreeLine: true,
        leading: CircleAvatar(
            backgroundImage: menuData.photoUrl != null
                ? NetworkImage(menuData.photoUrl!)
                : null),
        title: Text(menuData.name),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(menuData.description ?? ""),
          Row(
              children: menuData.allergens
                  .map((allergen) => Chip(
                        avatar: CircleAvatar(
                          backgroundColor: allergenColor[allergen],
                        ),
                        label: Text(allergen),
                      ))
                  .toList()),
        ]),
      ),
    );
  }
}
