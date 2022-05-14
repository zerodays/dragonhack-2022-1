import 'package:flutter/material.dart';
import 'package:frontend/util/theme.dart';
import 'package:frontend/widgets/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Allergens",
        theme: appTheme,
        home: BottomNavigation());
  }
}
