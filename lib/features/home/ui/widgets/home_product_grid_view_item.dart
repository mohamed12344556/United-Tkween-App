import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/core/utilities/extensions.dart';
import '../../../../core/routes/routes.dart';
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
          color: Color(0xFF292a2a),
          borderRadius: BorderRadius.circular(20),
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
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
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
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Text(
                    widget.book.title,
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
                        widget.book.getLocalizedCategory(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      if (!Platform.isIOS) ...[
                        if (widget.book.getFormattedPdfPrice != 0)
                          Row(
                            children: [
                              Text(
                                'PDF: ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.book.getFormattedPdfPrice}\$',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.book.getFormattedPrice}\$',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
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
