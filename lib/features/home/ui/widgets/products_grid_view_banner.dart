import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import '../../../admin/data/models/product_model.dart';

class ProductsGridViewBanner extends StatelessWidget {
  const ProductsGridViewBanner({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      height: screenHeight * 0.180,
      width: double.infinity,
      child: FancyShimmerImage(
        imageUrl: product.imageUrl ??
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
        errorWidget: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png'),
      ),
    );
  }
}