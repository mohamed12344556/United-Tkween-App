import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final String category;
  final String? type;
  final double price;
  final int quantity;
  final String? description;
  final String? imageUrl;
  final String? dateTime;
  final String? brand;
  final String? offer;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    this.type,
    required this.price,
    required this.quantity,
    this.description,
    this.imageUrl,
    this.dateTime,
    this.brand,
    this.offer,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    type,
    price,
    quantity,
    description,
    imageUrl,
  ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'type': type,
      'price': price,
      'quantity': quantity,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      type: json['type'],
      price:
          (json['price'] is int)
              ? (json['price'] as int).toDouble()
              : json['price'],
      quantity: json['quantity'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      dateTime: json['dateTime'],
      brand: json['brand'],
      offer: json['offer'],
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    String? type,
    double? price,
    int? quantity,
    String? description,
    String? imageUrl,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      type: type ?? this.type,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      dateTime: dateTime,
      brand: brand,
      offer: offer,
    );
  }
}
