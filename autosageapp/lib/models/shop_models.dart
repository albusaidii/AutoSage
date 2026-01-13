// lib/models/shop_models.dart

class Item {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Item({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Shop {
  final String id;
  final String name;
  final String address;
  final String logoUrl;
  final List<Item> items;

  Shop({
    required this.id,
    required this.name,
    required this.address,
    required this.logoUrl,
    required this.items,
  });
}
