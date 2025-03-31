// import 'package:flutter/material.dart';
// import 'package:united_formation_app/features/admin/data/models/product_model.dart';
// import '../../../../core/themes/app_colors.dart';
// import '../../data/book_model.dart';
// import 'home_product_grid_view_item.dart';

// class HomeProductsGridView extends StatelessWidget {
//   const HomeProductsGridView({
//     super.key,
//     required this.books,
//   });

//   final List<BookModel> books;

//   @override
//   Widget build(BuildContext context) {
//     var screenHeight = MediaQuery.of(context).size.height;
//     var screenWidth = MediaQuery.of(context).size.width;
//     return Material(
//       color: AppColors.darkBackground,
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: screenWidth / screenHeight * 1.50,
//           mainAxisSpacing: 10,
//           crossAxisSpacing: 10,
//         ),
//         itemBuilder: (context, index) => HomeProductsGridViewItem(book: books[index],),


//         itemCount: books.length,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:united_formation_app/features/admin/data/models/product_model.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/book_model.dart';
import 'home_product_grid_view_item.dart';

class HomeProductsGridView extends StatelessWidget {
  const HomeProductsGridView({
    super.key,
    required this.books,
  });

  final List<BookModel> books;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.white,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: screenWidth / screenHeight * 1.4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) => HomeProductsGridViewItem(
          book: books[index],
        ),
        itemCount: books.length,
      ),
    );
  }
}