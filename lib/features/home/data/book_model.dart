import 'package:flutter/cupertino.dart';
import 'package:united_formation_app/core/core.dart';

class BooksResponse {
  final String status;
  final List<BookModel> books;

  BooksResponse({
    required this.status,
    required this.books,
  });

  factory BooksResponse.fromJson(Map<String, dynamic> json) {
    return BooksResponse(
      status: json['status'] ?? '',
      books: (json['books'] as List<dynamic>?)
          ?.map((book) => BookModel.fromJson(book))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'books': books.map((book) => book.toJson()).toList(),
    };
  }
}


class BookModel {
  final String id;
  final String title;
  final String imageUrl;
  final String price;
  final String pdfPrice;
  final String bookType;
  final Category category;

  BookModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.pdfPrice,
    required this.bookType,
    required this.category,
  });

  String getLocalizedCategory(BuildContext context) {
    return context.isEnglish ? category.nameEn : category.nameAr;
  }

  double get getFormattedPrice {
    return double.tryParse(price) ?? 0.0;
  }

  double get getFormattedPdfPrice {
    return double.tryParse(pdfPrice) ?? 0.0;
  }


  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      price: json['price'] ?? '',
      pdfPrice: json['pdf_price'] ?? '',
      bookType: json['book_type'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'price': price,
      'pdf_price': pdfPrice,
      'book_type': bookType,
      'category': category.toJson(),
    };
  }
}
class Category {
  final String nameAr;
  final String nameEn;

  Category({
    required this.nameAr,
    required this.nameEn,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name_ar': nameAr,
      'name_en': nameEn,
    };
  }
}
