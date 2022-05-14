import 'package:flutter/material.dart';
import 'package:frontend/screens/map_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentPageIndex = 0;

  static const List<Widget> _navigationOptions = <Widget>[
    MapScreen(),
    Text("Index 1: List")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Find restaurant",
          ),
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
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
          ],
        ),
        body: _navigationOptions.elementAt(currentPageIndex));
  }
}
