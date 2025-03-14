import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/core/helper/format_double_number.dart';
import '../../../admin/data/models/product_model.dart';
import '../../data/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;
  String selectedCategory = "روايات";
  String selectedType = "ورقي";

  List<String> bookCategories = [
    "روايات",
    "تطوير الذات",
    "الكتب العلمية",
    "الكتب الدينية",
    "الكتب التقنية",
  ];
  List<String> bookTypes = [
    "PDF",
    "ورقي",
  ];

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.product.price * quantity;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.favorite_border, color: Colors.white),
      //       onPressed: () {},
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          Hero(
            tag: widget.product.id,
            child: Container(
              height: MediaQuery.of(context).size.height * .5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.product.imageUrl ??
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png',
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .5,
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            Text(
                              " 4.9 (862)",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      widget.product.description!,
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 16),

                    Text(
                      "Category",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          bookCategories.map((category) {
                            bool isSelected = category == selectedCategory;
                            return GestureDetector(
                              onTap: () {
                                // setState(() {
                                //   selectedCategory = category;
                                // });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? AppColors.primary
                                          : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),

                    SizedBox(height: 25),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                      bookTypes.map((type) {
                        bool isSelected = type == selectedType;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedType = type;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color:
                              isSelected
                                  ? AppColors.primary
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color:
                                isSelected
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 25),

                    Text(
                      "Price: ${formatNumber(widget.product.price)}\$",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Text(
                          "Total: ${formatNumber(totalPrice)}\$",
                          style: TextStyle(color: AppColors.primary, fontSize: 20),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.primary,
                                ),
                                child: Icon(Icons.remove, color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                "$quantity",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => quantity++),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColors.primary,
                                ),
                                child: Icon(Icons.add, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[800],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.favorite_border,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            text: "Add to cart",
                            onPressed: () {},
                            height: 55,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 10),
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                width: 40,
                height: 30,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightGrey,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color:AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
