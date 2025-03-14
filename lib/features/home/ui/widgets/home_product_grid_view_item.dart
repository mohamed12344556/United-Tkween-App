import 'package:flutter/material.dart';
import 'package:united_formation_app/constants.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/core/helper/format_double_number.dart';
import 'package:united_formation_app/core/utilities/extensions.dart';
import 'package:united_formation_app/features/admin/data/models/product_model.dart';
import '../../../../core/routes/routes.dart';
import '../../data/product_model.dart';
import 'product_offer_and_price.dart';
import 'products_grid_view_banner.dart';

class HomeProductsGridViewItem extends StatelessWidget {
  final ProductModel product;

  const HomeProductsGridViewItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (Constants.isAdmin) {
        //   // context.pushNamed(Routes.adminEditProductView, arguments: product);
        // } else {
        //   context.pushNamed(Routes.productDetailsView, arguments: product);
        // }
        context.pushNamed(Routes.productDetailsView, arguments: product);

      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF292a2a),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Hero(
                    tag: product.id,
                    child: ProductsGridViewBanner(product: product),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Likeeeeeed");
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.favorite_border, color:AppColors.primary,size: 20,),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          // '${product.price}\$',
                          product.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${formatNumber(product.price)}\$',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12),
                    // ProductOfferAndPrice(product: product),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
