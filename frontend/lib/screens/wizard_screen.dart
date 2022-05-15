import 'package:flutter/material.dart';
import 'package:frontend/models/allergens.dart';
import 'package:frontend/util/constants.dart';
import 'package:frontend/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({Key? key}) : super(key: key);

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen>
    with TickerProviderStateMixin {
  List<String> userAllergens = [];

  @override
  void initState() {
    super.initState();
    userAllergens =
        Provider.of<Allergens>(context, listen: false).userAllergens ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text("Hello!",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
                Text("Choose ingredients you're allergic to.",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            Wrap(
                spacing: 10.0,
                alignment: WrapAlignment.center,
                children: allergenColor.entries
                    .map((entry) => ChoiceChip(
                          label: Text(entry.key),
                          selected: userAllergens.contains(entry.key),
                          backgroundColor: entry.value,
                          labelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                userAllergens = [...userAllergens, entry.key];
                              });
                            } else {
                              setState(() {
                                userAllergens = userAllergens
                                    .where((element) => element != entry.key)
                                    .toList();
                              });
                            }
                          },
                        ))
                    .toList()),
            TextButton(
                onPressed: () {
                  Provider.of<Allergens>(context, listen: false)
                      .updateUserAllergens(userAllergens);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNavigation()));
                },
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold)),
                child: const Text("Next"))
          ],
        ),
      ),
    )));
  }
}
