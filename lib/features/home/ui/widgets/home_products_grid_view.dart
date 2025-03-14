import 'package:flutter/material.dart';
import 'package:united_formation_app/features/admin/data/models/product_model.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/product_model.dart';
import 'home_product_grid_view_item.dart';

class HomeProductsGridView extends StatelessWidget {
  const HomeProductsGridView({
    super.key,
    required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Material(
      color: AppColors.darkBackground,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: screenWidth / screenHeight * 1.65,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => HomeProductsGridViewItem(product: products[index],),


        itemCount: products.length,
      ),
    );
  }
}