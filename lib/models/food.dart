class Food {
  final int foodID;
  final String foodName;
  final double price;
  final String description;
  final String imageUrl;
  final int catID;

  Food({
    required this.foodID,
    required this.foodName,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.catID,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      foodID: json['foodID'],
      foodName: json['foodName'],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      catID: json['catID'],
    );
  }
}
