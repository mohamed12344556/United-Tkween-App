import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';

class AddProductCard extends StatelessWidget {
  const AddProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const AddProductScreen(),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueGrey[50],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_shopping_cart, size: 50, color: Colors.blue),
            // Lottie.asset(
            //   'assets/images/add_to_cart_2.json',
            //   // width: 100,
            //   height: 100,
            //   fit: BoxFit.fitHeight,
            // ),
            SizedBox(height: 10),
            Text(
              S.of(context).addProduct,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
