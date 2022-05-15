import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/allergens.dart';

class CurrentAllergens extends StatelessWidget {
  const CurrentAllergens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String>? userAllergens = context
        .select<Allergens, List<String>?>((Allergens all) => all.userAllergens);

    return SizedBox(
      height: 60,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: userAllergens!
              .map((allergen) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Chip(
                      backgroundColor: const Color.fromRGBO(78, 99, 86, 1),
                      label: Text(allergen,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ))
              .toList()),
    );
  }
}
