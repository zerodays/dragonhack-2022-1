import 'package:flutter/material.dart';
import 'package:frontend/models/allergens.dart';
import 'package:frontend/screens/list_screen.dart';
import 'package:frontend/screens/map_screen.dart';
import 'package:frontend/screens/wizard_screen.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<Allergens>(context, listen: false).setOnInitCallback((status) {
      if (status == AppStatus.notInitialized) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WizardScreen()));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const List<Widget> _navigationOptions = <Widget>[
    MapScreen(),
    ListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            if (index >= 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const WizardScreen()));
              return;
            }

            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.explore), label: "Map"),
            NavigationDestination(
              icon: Icon(Icons.list),
              label: 'List',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
        body: _navigationOptions.elementAt(currentPageIndex));
  }
}
