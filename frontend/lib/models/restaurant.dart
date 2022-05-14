import 'package:frontend/models/address.dart';

class Restaurant {
  final int restaurantId;
  final String name;
  final String? description;
  final double latitude;
  final double longitude;
  final double? rating;
  final String? imageURL;
  final Address? address;

  const Restaurant(
      {required this.restaurantId,
      required this.name,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.rating,
      required this.imageURL,
      required this.address});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        restaurantId: json['id'],
        name: json['name'],
        description: json['description'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        rating: json['rating'],
        imageURL: json['image_url'],
        address: Address.fromJson(json['address']));
  }
}
