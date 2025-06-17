import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../admin/data/models/product_model.dart';

class ProductOfferAndPrice extends StatelessWidget {
  const ProductOfferAndPrice({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    var random = Random();
    int randomNumber = random.nextInt(60);
    return Row(
      children: [
        if (product.offer == true)
        Container(
          decoration: BoxDecoration(
            color: product.offer == false ? Colors.transparent : Colors.green,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Text(
              '$randomNumber% OFF',
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const Expanded(
          child: SizedBox(),
        ),
        if(Constants.isAdmin)
        GestureDetector(
          onTap: () {
            // buildAwesomeDialogWarning(context,
            //     title: 'Delete Product',
            //     message: 'Warning! Deleting this product is permanent. \n Are you absolutely sure?',
            //     btnOkOnPress: () {
            //       // BlocProvider.of<ProductCubit>(context)
            //       //     .deleteProduct(productId: product.id);
            //     }, btnCancelOnPress: () {});
          },
          child: const CircleAvatar(
            backgroundColor: Colors.red,
            radius: 16,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }
}