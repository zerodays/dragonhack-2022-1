class Menu {
  final int menuId;
  final int restaurantId;
  final String name;
  final String? description;
  final String? photoUrl;
  final List<dynamic> allergens;

  const Menu(
      {required this.menuId,
      required this.restaurantId,
      required this.name,
      required this.description,
      required this.photoUrl,
      required this.allergens});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
        menuId: json['id'],
        restaurantId: json['restaurant_id'],
        name: json['name'],
        description: json['description'],
        photoUrl: json['photo_url'],
        allergens: json['allergens']);
  }
}
