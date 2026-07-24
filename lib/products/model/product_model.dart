class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;
  final bool isFavourite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.isFavourite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      isFavourite: json['isFavourite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isFavourite': isFavourite,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? imageUrl,
    bool? isFavourite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
