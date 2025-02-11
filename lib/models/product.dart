class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  bool isLiked;
  final String? city;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.isLiked = false,
    this.city
  });
}
