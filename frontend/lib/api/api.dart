import 'dart:convert';

import 'package:frontend/models/restaurant.dart';
import 'package:http/http.dart' as http;

import '../models/menu.dart';

const apiUrl = 'http://192.168.129.206:8000/api/v1';

Future<List<Restaurant>> fetchRestaurants() async {
  final response = await http
      .get(Uri.parse('$apiUrl/restaurants/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<Restaurant>.from(
        jsonDecode(response.body).map((r) => Restaurant.fromJson(r)));

    //return Restaurant.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load restaurants');
  }
}

Future<List<Menu>> fetchMenu(int restaurantId) async {
  final response = await http
      .get(Uri.parse('$apiUrl/restaurants/$restaurantId/menu/'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return List<Menu>.from(
        jsonDecode(response.body).map((menu) => Menu.fromJson(menu)));

    //return Restaurant.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load restaurants');
  }
}


