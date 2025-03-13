// class ProductModel {
//   String id;
//   String dateTime;

//   String category;

//   String brand;

//   String description;

//   String? imageUrl;

//   String name;
//   double price;

//   bool offer;

//   ProductModel({
//     required this.id,
//     required this.dateTime,
//     required this.category,
//     required this.brand,
//     required this.description,
//     required this.imageUrl,
//     required this.name,
//     required this.price,
//     required this.offer,
//   });

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id'],
//       dateTime: json['dateTime'],
//       category: json['category'],
//       brand: json['brand'],
//       description: json['description'],
//       imageUrl: json['imageUrl'],
//       name: json['name'],
//       price: json['price'],
//       offer: json['offer'],
//     );
//   }

//   ProductModel copyWith({
//     String? id,
//     String? name,
//     double? price,
//     String? dateTime,
//     String? description,
//     String? imageUrl,
//     String? category,
//     String? brand,
//     bool? offer,
//   }) {
//     return ProductModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       price: price ?? this.price,
//       dateTime: dateTime ?? this.dateTime,
//       description: description ?? this.description,
//       imageUrl: imageUrl ?? this.imageUrl,
//       category: category ?? this.category,
//       brand: brand ?? this.brand,
//       offer: offer ?? this.offer,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'dateTime': dateTime,
//       'category': category,
//       'brand': brand,
//       'description': description,
//       'imageUrl': imageUrl,
//       'name': name,
//       'price': price,
//       'offer': offer
//     };
//   }
// }