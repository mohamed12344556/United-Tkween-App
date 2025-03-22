import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:united_formation_app/core/core.dart';
import '../../../../core/routes/routes.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';


class FavoritesView extends StatefulWidget {
  FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  late Box<BookModel> favoritesBox;

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box<BookModel>('favorites');
  }

  @override
  Widget build(BuildContext context) {
    List<BookModel> products = favoritesBox.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الكتب المفضلة'),
        scrolledUnderElevation: 0,
      ),
      body: products.isEmpty
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
                          borderRadius: const BorderRadiusDirectional.only(
                            topStart: Radius.circular(20),
                            bottomStart: Radius.circular(20),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  products[index].imageUrl.asFullImageUrl,
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            products[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "PDf Price :  ${products[index].getFormattedPdfPrice} EGP",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Paper Price :  ${products[index].getFormattedPrice} EGP",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    favoritesBox.delete(products[index].id);
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[800],
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                            ],
                          ),
                          const SizedBox(height: 15),
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
