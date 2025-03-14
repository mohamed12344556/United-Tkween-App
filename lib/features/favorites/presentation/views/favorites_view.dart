import 'package:flutter/material.dart';
import 'package:united_formation_app/core/core.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../admin/data/models/product_model.dart';

class FavoritesView extends StatelessWidget {
  FavoritesView({super.key});

  // // مثال على قائمة الكتب المفضلة
  // final List<String> favoriteBooks = const [
  //   'كتاب قواعد العشق الأربعون',
  //   'كتاب الخيميائي',
  //   'كتاب العادات السبع للناس الأكثر فعالية',
  //   'كتاب نظرية الفستق',
  //   'كتاب لأنك الله',
  // ];

  List<ProductModel> products = [
    ProductModel(
      id: '1',
      dateTime: DateTime.now().toString(),
      category: 'Fiction',
      brand: 'Penguin Books',
      description: 'A thrilling mystery novel full of unexpected twists.',
      imageUrl:
          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=1000',
      name: 'The Silent Patient',
      price: 250.0,
      offer: '20%',
      quantity: 10,
      type: "pdf",
    ),
    ProductModel(
      id: '3',
      dateTime: DateTime.now().toString(),
      category: 'Self-Help',
      brand: 'Simon & Schuster',
      description: 'A guide to building good habits and breaking bad ones.',
      imageUrl:
          'https://images.unsplash.com/photo-1531988042231-d39a9cc12a9a?q=80&w=1000',
      name: 'Atomic Habits',
      price: 200.0,
      offer: '20%',
      quantity: 10,
      type: "ورقي",
    ),
    ProductModel(
      id: '4',
      dateTime: DateTime.now().toString(),
      category: 'Biography',
      brand: 'Macmillan Publishers',
      description:
          'The inspiring life story of one of the greatest minds in history.',
      imageUrl:
          'https://images.unsplash.com/photo-1541963463532-d68292c34b19?q=80&w=1000',
      name: 'Steve Jobs',
      price: 350.0,
      offer: '20%',
      quantity: 10,
      type: "صوتي",
    ),
    ProductModel(
      id: '5',
      dateTime: DateTime.now().toString(),
      category: 'Fantasy',
      brand: 'Bloomsbury',
      description: 'The first book in the legendary Harry Potter series.',
      imageUrl:
          'https://images.unsplash.com/photo-1629992101753-56d196c8aabb?q=80&w=1000',
      name: 'Harry Potter and the Sorcerer\'s Stone',
      price: 280.0,
      offer: '20%',
      quantity: 10,
      type: "ورقي",
    ),
    ProductModel(
      id: '6',
      dateTime: DateTime.now().toString(),
      category: 'History',
      brand: 'Oxford University Press',
      description: 'A detailed account of World War II from start to finish.',
      imageUrl:
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=1000',
      name: 'The Second World War',
      price: 400.0,
      offer: '20%',
      quantity: 10,
      type: "pdf",
    ),
    ProductModel(
      id: '7',
      dateTime: DateTime.now().toString(),
      category: 'Psychology',
      brand: 'Random House',
      description:
          'Exploring the power of human thinking and its impact on decision making.',
      imageUrl:
          'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=1000',
      name: 'Thinking, Fast and Slow',
      price: 270.0,
      offer: '20%',
      quantity: 10,
      type: "pdf",
    ),
    ProductModel(
      id: '8',
      dateTime: DateTime.now().toString(),
      category: 'Business',
      brand: 'Harvard Business Review Press',
      description: 'How to develop a mindset that leads to success.',
      imageUrl:
          'https://images.unsplash.com/photo-1589998059171-988d887df646?q=80&w=1000',
      name: 'The Lean Startup',
      price: 320.0,
      offer: '20%',
      quantity: 10,
      type: "pdf",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الكتب المفضلة'),
        scrolledUnderElevation: 0,
      ),
      body:
          products.isEmpty
              ? const Center(
                child: Text(
                  'لا يوجد كتب مفضلة حتى الآن',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        Routes.productDetailsView,
                        arguments: products[index],
                      );
                    },

                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * .22,
                      child: Card(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Hero(
                                tag: products[index].id,
                                child: ClipRRect(
                                  borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(20),
                                    bottomStart: Radius.circular(20),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          products[index].imageUrl!,
                                        ),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    products[index].name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "${products[index].description}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 15),

                                  Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          // color: AppColors.lightGrey,
                                          color: AppColors.lightGrey,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                        ),

                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            products[index].type!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),

                                      GestureDetector(
                                        onTap: () {
                                          print("Hello World");
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[800],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Icon(
                                              Icons.favorite_border,
                                              color: AppColors.primary,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
