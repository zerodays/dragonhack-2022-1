import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../util/constants.dart';
import 'package:frontend/api/api.dart';

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
                ? NetworkImage(
                    '$apiUrl/cigani_cors/?url=${menuData.photoUrl!}',
                  )
                : null),
        title: Text(menuData.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(menuData.description ?? ""),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                  children: menuData.allergens
                      .map((allergen) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Chip(
                              label: Text(allergen),
                            ),
                          ))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
