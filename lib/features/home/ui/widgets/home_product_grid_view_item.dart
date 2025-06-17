// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:united_formation_app/core/core.dart';
// import 'package:united_formation_app/core/utilities/extensions.dart';
// import '../../../../core/routes/routes.dart';
// import '../../data/book_model.dart';
// import 'products_grid_view_banner.dart';

// class HomeProductsGridViewItem extends StatefulWidget {
//   final BookModel book;

//   const HomeProductsGridViewItem({super.key, required this.book});

//   @override
//   State<HomeProductsGridViewItem> createState() =>
//       _HomeProductsGridViewItemState();
// }

// class _HomeProductsGridViewItemState extends State<HomeProductsGridViewItem> {
//   late Box<BookModel> favoritesBox;
//   bool isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     favoritesBox = Hive.box<BookModel>('favorites');
//     isFavorite = favoritesBox.containsKey(widget.book.id);
//   }

//   void toggleFavorite() {
//     setState(() {
//       if (isFavorite) {
//         favoritesBox.delete(widget.book.id);
//       } else {
//         favoritesBox.put(widget.book.id, widget.book);
//       }
//       isFavorite = !isFavorite;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         context.pushNamed(Routes.productDetailsView, arguments: widget.book);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Color(0xFF292a2a),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               alignment: Alignment.topRight,
//               children: [
//                 Hero(
//                   tag: widget.book.id,
//                   child: ProductsGridViewBanner(book: widget.book),
//                 ),
//                 GestureDetector(
//                   onTap: toggleFavorite,
//                   child: Container(
//                     padding: EdgeInsets.all(4),
//                     margin: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[800],
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(
//                       isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: AppColors.primary,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 4),
//                   Text(
//                     widget.book.title,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       height: 1.3,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Text(
//                         widget.book.getLocalizedCategory(context),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Column(
//                     children: [
//                       if (!Platform.isIOS) ...[
//                         if (widget.book.getFormattedPdfPrice != 0)
//                           Row(
//                             children: [
//                               Text(
//                                 'PDF: ',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '${widget.book.getFormattedPdfPrice}\$',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                       const SizedBox(height: 4),
//                       if (!Platform.isIOS) ...[
//                         if (widget.book.getFormattedPrice != 0)
//                           Row(
//                             children: [
//                               Text(
//                                 'Paper: ',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               Text(
//                                 '${widget.book.getFormattedPrice}\$',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:united_formation_app/core/core.dart';
import '../../data/book_model.dart';
import 'products_grid_view_banner.dart';

class HomeProductsGridViewItem extends StatefulWidget {
  final BookModel book;

  const HomeProductsGridViewItem({super.key, required this.book});

  @override
  State<HomeProductsGridViewItem> createState() =>
      _HomeProductsGridViewItemState();
}

class _HomeProductsGridViewItemState extends State<HomeProductsGridViewItem> {
  late Box<BookModel> favoritesBox;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    favoritesBox = Hive.box<BookModel>('favorites');
    isFavorite = favoritesBox.containsKey(widget.book.id);
  }

  void toggleFavorite() {
    setState(() {
      if (isFavorite) {
        favoritesBox.delete(widget.book.id);
      } else {
        favoritesBox.put(widget.book.id, widget.book);
      }
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.productDetailsView, arguments: widget.book);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Hero(
                  tag: widget.book.id,
                  child: ProductsGridViewBanner(book: widget.book),
                ),
                GestureDetector(
                  onTap: toggleFavorite,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    widget.book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.book.getLocalizedCategory(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!Platform.isIOS) ...[
                        if (widget.book.getFormattedPdfPrice != 0)
                          Row(
                            children: [
                              Text(
                                'PDF: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.book.getFormattedPdfPrice} ر.س',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                      ],
                      const SizedBox(height: 4),
                      if (!Platform.isIOS) ...[
                        if (widget.book.getFormattedPrice != 0)
                          Row(
                            children: [
                              Text(
                                'Paper: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.text,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.book.getFormattedPrice} ر.س',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
