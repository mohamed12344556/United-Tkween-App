import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';
import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/core.dart';
import '../../data/models/cart_model.dart';
import '../../../../generated/l10n.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box<CartItemModel> cartBox;
  bool _isGuest = false;

  // int shippingCost = 48;

  int get subtotal => cartBox.values.fold(
    0,
    (sum, item) => sum + (item.unitPrice * item.quantity).toInt(),
  );

  // int get totalAmount => subtotal + shippingCost;
  int get totalAmount => subtotal;

  @override
  Widget build(BuildContext context) {
    final cartItems = cartBox.values.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: const SizedBox(),
        elevation: 0,
        title: Text(
          S.of(context).shoppingCart,
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isGuest ? _buildGuestModeView() : _buildCartView(cartItems),
    );
  }

  void deleteItem(int index) async {
    await cartBox.deleteAt(index);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartItemModel>('CartBox');
    _checkGuestStatus();
  }

  // void proceedToSummaryPage() {
  //   final cartItems = cartBox.values.toList();

  //   if (cartItems.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('السلة فارغة. لا يمكن إتمام عملية الشراء.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   // Navigator.of(context).pushNamed(
  //   //   Routes.orderSummaryView,
  //   //   arguments: {
  //   //     'cartItems': cartItems,
  //   //     'subtotal': subtotal,
  //   //     'shippingCost': shippingCost,
  //   //     'totalAmount': totalAmount,
  //   //   },
  //   // );

  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder:
  //           (context) => OrderSummaryPage(
  //             cartItems: cartItems,
  //             subtotal: subtotal,
  //             shippingCost: shippingCost,
  //             totalAmount: totalAmount,
  //           ),
  //     ),
  //   );
  // }

  void proceedToSummaryPage() {
    final cartItems = cartBox.values.toList();

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).emptyCartError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder:
    //         (context) => TapPaymentScreen(
    //           tapPaymentUrl:
    //               "https://checkout.tap.company/?mode=page&themeMode=&language=en&token=eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjY4NTEyOWQ1ZWQ4YTQ3NDllZjg3YWY4ZCJ9.moHMRi-J_biVdaI7rCkwYBLrDCetGBC1QgRn1BeEHC4",
    //         ),
    //   ),
    // );
    context.pushNamed(
      Routes.orderSummaryView,
      arguments: {
        'cartItems': cartItems,
        'subtotal': subtotal,
        // 'shippingCost': shippingCost,
        'totalAmount': totalAmount,
      },
    );
  }

  // تعديل وظيفة الإرسال عبر الواتساب مع دعم وضع الضيف
  Future<void> sendToWhatsApp() async {
    // التحقق مما إذا كان المستخدم في وضع الضيف
    if (_isGuest) {
      if (mounted) {
        // عرض مربع حوار القيود إذا كان في وضع الضيف
        await context.checkGuestRestriction(
          featureName: S.of(context).whatsappOrder,
        );
      }
      return;
    }

    // الكود الأصلي لإرسال رسالة واتساب للمستخدمين المسجلين
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
    message += "*${S.of(context).orderDetails}:*\n";

    for (int i = 0; i < cartItems.length; i++) {
      final item = cartItems[i];
      message += "${i + 1}. ${item.bookName} (${item.type})\n";
      message +=
          "   ${S.of(context).price}:  ${S.of(context).currency}${item.unitPrice.toStringAsFixed(2)} × ${item.quantity} =  ${S.of(context).currency}${(item.unitPrice * item.quantity).toStringAsFixed(2)}\n";
    }

    message +=
        "\n*${S.of(context).subtotal}:*  ${S.of(context).currency}${subtotal.toStringAsFixed(2)}\n";
    // message += "*تكلفة الشحن:*  ${S.of(context).currency}${shippingCost.toStringAsFixed(2)}\n";
    message +=
        "*${S.of(context).totalAmount}:*  ${S.of(context).currency}${totalAmount.toStringAsFixed(2)}\n";

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
        SnackBar(
          content: Text(S.of(context).whatsappNotInstalled),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void updateQuantity(int index, int change) async {
    final item = cartBox.getAt(index);
    if (item == null) return;

    final newQuantity = (item.quantity + change).clamp(1, 10);
    item
      ..quantity = newQuantity
      ..save();

    setState(() {});
  }

  // واجهة المستخدم للمسجلين
  Widget _buildCartView(List<CartItemModel> cartItems) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:
          cartItems.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: AppColors.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).emptyCart,
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).startShopping,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${cartItems.length} ${S.of(context).itemsCount}',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade700,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.bookName,
                                      style: TextStyle(
                                        color: AppColors.text,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      item.type,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ' ${S.of(context).currency}${item.unitPrice}',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  if (0 > 1) ...[
                                    IconButton(
                                      icon: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.lightGrey,
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: AppColors.primary,
                                          size: 16,
                                        ),
                                      ),
                                      onPressed:
                                          () => updateQuantity(index, -1),
                                    ),
                                    Text(
                                      '${item.quantity}',
                                      style: TextStyle(
                                        color: AppColors.text,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                      onPressed: () => updateQuantity(index, 1),
                                    ),
                                  ],
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.shade400,
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade700, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade100,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).subtotal,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${S.of(context).currency} $subtotal',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(
                        //       'Shipping',
                        //       style: TextStyle(
                        //         color: AppColors.textSecondary,
                        //         fontSize: 16,
                        //       ),
                        //     ),
                        //     Text(
                        //       '${S.of(context).currency} $shippingCost',
                        //       style: TextStyle(
                        //         color: AppColors.text,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 12),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).totalAmount,
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${S.of(context).currency} $totalAmount',
                              style: TextStyle(
                                color: AppColors.primary,
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
                    // onPressed: sendToWhatsApp,
                    onPressed: proceedToSummaryPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      S.of(context).proceedToCheckout,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  // واجهة المستخدم للضيف
  Widget _buildGuestModeView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              S.of(context).guestMode,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).guestModeMessage,
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                GuestModeManager.resetGuestMode().then((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.loginView,
                    (route) => false,
                    arguments: {'fresh_start': true},
                  );
                });
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: Text(S.of(context).loginToAccessCart),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(Routes.hostView, (route) => false);
              },
              child: Text(
                S.of(context).returnToBrowse,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // التحقق من حالة الضيف
  Future<void> _checkGuestStatus() async {
    final isGuest = await GuestModeManager.isGuestMode();
    if (mounted) {
      setState(() {
        _isGuest = isGuest;
      });
    }
  }
}
