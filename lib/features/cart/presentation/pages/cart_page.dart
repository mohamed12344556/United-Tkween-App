import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box<CartItemModel> cartBox;

  int shippingCost = 48;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartItemModel>('CartBox');
  }

  int get subtotal => cartBox.values.fold(
    0,
    (sum, item) => sum + (item.unitPrice * item.quantity).toInt(),
  );

  int get totalAmount => subtotal + shippingCost;

  void updateQuantity(int index, int change) async {
    final item = cartBox.getAt(index);
    if (item == null) return;

    final newQuantity = (item.quantity + change).clamp(1, 10);
    await item
      ..quantity = newQuantity
      ..save();

    setState(() {});
  }

  void deleteItem(int index) async {
    await cartBox.deleteAt(index);
    setState(() {});
  }

  // New function to handle WhatsApp checkout
  void sendToWhatsApp() async {
    // Get all cart items
    final cartItems = cartBox.values.toList();

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('السلة فارغة. لا يمكن إتمام عملية الشراء.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Format cart items for WhatsApp message
    String message = "📚 *طلب جديد* 📚\n\n";
    message += "*تفاصيل الطلب:*\n";

    for (int i = 0; i < cartItems.length; i++) {
      final item = cartItems[i];
      message += "${i + 1}. ${item.bookName} (${item.type})\n";
      message +=
          "   السعر: \$${item.unitPrice.toStringAsFixed(2)} × ${item.quantity} = \$${(item.unitPrice * item.quantity).toStringAsFixed(2)}\n";
    }

    message += "\n*المجموع الفرعي:* \$${subtotal.toStringAsFixed(2)}\n";
    message += "*تكلفة الشحن:* \$${shippingCost.toStringAsFixed(2)}\n";
    message += "*إجمالي المبلغ:* \$${totalAmount.toStringAsFixed(2)}\n";

    // Encode the message for URL
    final encodedMessage = Uri.encodeComponent(message);

    // Replace with your actual WhatsApp number
    final whatsappNumber =
        "+201060796400"; // Change this to your business WhatsApp number

    // Create WhatsApp URL
    final whatsappUrl = "https://wa.me/$whatsappNumber?text=$encodedMessage";

    // Launch URL
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يمكن فتح WhatsApp. يرجى التأكد من تثبيت التطبيق.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = cartBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        scrolledUnderElevation: 0,
        leading: const SizedBox(),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            cartItems.isEmpty
                ? Center(
                  child: Text(
                    'السلة فارغة',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                )
                : Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${cartItems.length} Items',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
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
                                  child: Icon(
                                    Icons.book,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.bookName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        item.type,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${item.unitPrice}',
                                        style: const TextStyle(
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
                                      icon: Icon(
                                        Icons.remove,
                                        color: AppColors.primary,
                                      ),
                                      onPressed:
                                          () => updateQuantity(index, -1),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: AppColors.primary,
                                      ),
                                      onPressed: () => updateQuantity(index, 1),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => deleteItem(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Subtotal',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '\$$subtotal',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shipping',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '\$$shippingCost',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total amount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$$totalAmount',
                                style: const TextStyle(
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
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed:
                          sendToWhatsApp, // Updated to use the new function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Checkout via WhatsApp',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
