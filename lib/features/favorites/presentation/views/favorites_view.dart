// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:united_formation_app/core/core.dart';
// import '../../../../core/routes/routes.dart';
// import 'package:united_formation_app/features/home/data/book_model.dart';

// class FavoritesView extends StatefulWidget {
//   FavoritesView({super.key});

//   @override
//   State<FavoritesView> createState() => _FavoritesViewState();
// }

// class _FavoritesViewState extends State<FavoritesView> {
//   late Box<BookModel> favoritesBox;

//   @override
//   void initState() {
//     super.initState();
//     favoritesBox = Hive.box<BookModel>('favorites');
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<BookModel> products = favoritesBox.values.toList();

//     return Scaffold(
//       appBar: AppBar(
//         leading: SizedBox(),
//         title: const Text('الكتب المفضلة'),
//         scrolledUnderElevation: 0,
//       ),
//       body:
//           products.isEmpty
//               ? const Center(
//                 child: Text(
//                   'لا يوجد كتب مفضلة حتى الآن',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               )
//               : ListView.builder(
//                 itemCount: products.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       context.pushNamed(
//                         Routes.productDetailsView,
//                         arguments: products[index],
//                       );
//                     },
//                     child: SizedBox(
//                       height: MediaQuery.sizeOf(context).height * .22,
//                       child: Card(
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Hero(
//                                 tag: products[index].id,
//                                 child: ClipRRect(
//                                   borderRadius:
//                                       const BorderRadiusDirectional.only(
//                                         topStart: Radius.circular(20),
//                                         bottomStart: Radius.circular(20),
//                                       ),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       image: DecorationImage(
//                                         image: NetworkImage(
//                                           products[index]
//                                               .imageUrl
//                                               .asFullImageUrl,
//                                         ),
//                                         fit: BoxFit.fitHeight,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             Expanded(
//                               flex: 2,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 10),
//                                   Text(
//                                     products[index].title,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 30),
//                                   Row(
//                                     children: [
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           if (!Platform.isIOS) ...[
//                                             if (products[index]
//                                                     .getFormattedPdfPrice !=
//                                                 0)
//                                               Text(
//                                                 "PDf Price :  ${products[index].getFormattedPdfPrice} EGP",
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                             const SizedBox(height: 10),
//                                             if (products[index]
//                                                     .getFormattedPrice !=
//                                                 0)
//                                               Text(
//                                                 "Paper Price :  ${products[index].getFormattedPrice} EGP",
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                           ],
//                                         ],
//                                       ),
//                                       Spacer(),
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             favoritesBox.delete(
//                                               products[index].id,
//                                             );
//                                           });
//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: Colors.grey[800],
//                                           ),
//                                           child: const Padding(
//                                             padding: EdgeInsets.all(12.0),
//                                             child: Icon(
//                                               Icons.delete_outline,
//                                               color: AppColors.primary,
//                                               size: 18,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(width: 15),
//                                     ],
//                                   ),
//                                   const SizedBox(height: 15),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';

import '../../../../generated/l10n.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: SizedBox(),
        title: Text(
          S.of(context).favoritesTitle,
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body:
          products.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).favoritesEmptyTitle,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).favoritesEmptySubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        Routes.productDetailsView,
                        arguments: products[index],
                      );
                    },
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * .22,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Hero(
                              tag: products[index].id,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadiusDirectional.only(
                                      topStart: Radius.circular(16),
                                      bottomStart: Radius.circular(16),
                                    ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        products[index].imageUrl.asFullImageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index].title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppColors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    products[index].getLocalizedCategory(
                                      context,
                                    ),
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (!Platform.isIOS) ...[
                                            if (products[index]
                                                    .getFormattedPdfPrice !=
                                                0)
                                              Text(
                                                "الكتروني: ${products[index].getFormattedPdfPrice} ${S.of(context).currency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                            const SizedBox(height: 6),
                                            if (products[index]
                                                    .getFormattedPrice !=
                                                0)
                                              Text(
                                                "ورقي: ${products[index].getFormattedPrice} ${S.of(context).currency}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                          ],
                                        ],
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            favoritesBox.delete(
                                              products[index].id,
                                            );
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.lightGrey,
                                          ),
                                          child: Padding(
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
