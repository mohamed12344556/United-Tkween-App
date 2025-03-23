import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';

class CategoriesResponse {
  final String status;
  final List<CategoryModel> categories;

  CategoriesResponse({
    required this.status,
    required this.categories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      status: json['status'] ?? '',
      categories: (json['categories'] as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList(),
    );
  }
}



class CategoryModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String slug;

  CategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    required this.slug,
  });
  String getLocalizedCategory(BuildContext context) {
    return context.isEnglish ? nameEn : nameAr;
  }
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      icon: json['icon'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}
