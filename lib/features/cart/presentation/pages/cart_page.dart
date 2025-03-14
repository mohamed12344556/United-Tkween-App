import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'The Great Gatsby',  // اسم الكتاب الأول
      'color': 'Hardcover, 400 pages',  // هذا يمكن أن يكون وصف الكتاب أو طبعته
      'price': 15,  // السعر
      'quantity': 1,  // الكمية
    },
    {
      'name': '1984',  // اسم الكتاب الثاني
      'color': 'Paperback, 328 pages',  // وصف الكتاب
      'price': 12,  // السعر
      'quantity': 1,  // الكمية
    },
    {
      'name': 'To Kill a Mockingbird',  // اسم الكتاب الثالث
      'color': 'Hardcover, 324 pages',  // وصف الكتاب
      'price': 18,  // السعر
      'quantity': 1,  // الكمية
    },
  ];

  int shippingCost = 48;

  int get subtotal => cartItems.fold(
    0,
    (sum, item) => sum + ((item['price'] as int) * (item['quantity'] as int)),
  );

  int get totalAmount => subtotal + shippingCost;

  void updateQuantity(int index, int change) {
    setState(() {
      cartItems[index]['quantity'] = (cartItems[index]['quantity'] + change)
          .clamp(1, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
        leading: SizedBox(),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '3 Items',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartItems[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.book,color: AppColors.primary),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item['color'],
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '\$${item['price']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove,color:AppColors.primary),
                              onPressed: () => updateQuantity(index, -1),
                            ),
                            Text(
                              '${item['quantity']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color:AppColors.primary),
                              onPressed: () => updateQuantity(index, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        '\$$subtotal',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shipping',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        '\$$shippingCost',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total amount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$$totalAmount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
