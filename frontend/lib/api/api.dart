import 'dart:convert';

import 'package:frontend/models/restaurant.dart';
import 'package:http/http.dart' as http;

import '../models/menu.dart';

const apiUrl = 'https://dragonhack.zerodays.dev/api/v1';

Future<List<Restaurant>> fetchRestaurants(
    String? search, List<String>? filter) async {
  var url = '$apiUrl/restaurants/';
  if (search != null) {
    url += '?search=$search';
  } else {
    url += "?search=";
  }

  final joinedFilter = filter?.join(",").toUpperCase().replaceAll(" ", "_");
  if (joinedFilter != null) {
    url += "&exclude=$joinedFilter";
  }

  final response = await http.get(Uri.parse(url));

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

Future<List<Menu>> fetchMenu(int restaurantId, List<String>? filter) async {
  final joinedFilter = filter?.join(",").toUpperCase().replaceAll(" ", "_");

  print(joinedFilter);

  final url = filter != null
      ? Uri.parse(
          '$apiUrl/restaurants/$restaurantId/menu/?exclude=$joinedFilter')
      : Uri.parse('$apiUrl/restaurants/$restaurantId/menu/');

  final response = await http.get(url);

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
