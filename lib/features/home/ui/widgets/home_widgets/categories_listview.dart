import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/core.dart';


class CategoriesListView extends StatefulWidget {
  final List<ProductCategoryOrBrandModel> categoryItems;

  const CategoriesListView({super.key, required this.categoryItems});

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CategoriesListviewItem(
            onTap: () {
              // BlocProvider.of<ProductsCubit>(context)
              //     .filterProductsByCategory(
              //     widget.categoryItems[index].name);
              // setState(() {
              //   currentIndex = index;
              // });
            },
            categoryItem: widget.categoryItems[index],
            isSelected: index == currentIndex,
          );
        },
        itemCount: widget.categoryItems.length,
      ),
    );

  }
}

class CategoriesListviewItem extends StatelessWidget {
  final Function()? onTap;
  final ProductCategoryOrBrandModel categoryItem;
  final bool isSelected;

  const CategoriesListviewItem({
    super.key,
    required this.onTap,
    required this.categoryItem,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Chip(
          padding: EdgeInsets.symmetric(vertical: 12 ,horizontal:12),
          backgroundColor: isSelected ? AppColors.primary :AppColors.inputBackgroundDark,
          label: Text(categoryItem.name, style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
          ),),
        ),
      ),
    );
  }
}
class ProductCategoryOrBrandModel {
  final String id;

  final String name;

  const ProductCategoryOrBrandModel({required this.id, required this.name});

  factory ProductCategoryOrBrandModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryOrBrandModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
