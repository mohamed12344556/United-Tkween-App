// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:united_formation_app/core/routes/routes.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';
// import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
// import '../../../../core/themes/app_colors.dart';
// import '../../data/cart_model.dart';

// class CartPage extends StatefulWidget {
//   const CartPage({super.key});

//   @override
//   State<CartPage> createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   late Box<CartItemModel> cartBox;
//   bool _isGuest = false;

//   int shippingCost = 48;

//   @override
//   void initState() {
//     super.initState();
//     cartBox = Hive.box<CartItemModel>('CartBox');
//     _checkGuestStatus();
//   }

//   // التحقق من حالة الضيف
//   Future<void> _checkGuestStatus() async {
//     final isGuest = await GuestModeManager.isGuestMode();
//     if (mounted) {
//       setState(() {
//         _isGuest = isGuest;
//       });
//     }
//   }

//   int get subtotal => cartBox.values.fold(
//     0,
//     (sum, item) => sum + (item.unitPrice * item.quantity).toInt(),
//   );

//   int get totalAmount => subtotal + shippingCost;

//   void updateQuantity(int index, int change) async {
//     final item = cartBox.getAt(index);
//     if (item == null) return;

//     final newQuantity = (item.quantity + change).clamp(1, 10);
//     await item
//       ..quantity = newQuantity
//       ..save();

//     setState(() {});
//   }

//   void deleteItem(int index) async {
//     await cartBox.deleteAt(index);
//     setState(() {});
//   }

//   // تعديل وظيفة الإرسال عبر الواتساب مع دعم وضع الضيف
//   Future<void> sendToWhatsApp() async {
//     // التحقق مما إذا كان المستخدم في وضع الضيف
//     if (_isGuest) {
//       if (mounted) {
//         // عرض مربع حوار القيود إذا كان في وضع الضيف
//         await context.checkGuestRestriction(featureName: "الطلب عبر واتساب");
//       }
//       return;
//     }

//     // الكود الأصلي لإرسال رسالة واتساب للمستخدمين المسجلين
//     // Get all cart items
//     final cartItems = cartBox.values.toList();

//     if (cartItems.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('السلة فارغة. لا يمكن إتمام عملية الشراء.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     // Format cart items for WhatsApp message
//     String message = "📚 *طلب جديد* 📚\n\n";
//     message += "*تفاصيل الطلب:*\n";

//     for (int i = 0; i < cartItems.length; i++) {
//       final item = cartItems[i];
//       message += "${i + 1}. ${item.bookName} (${item.type})\n";
//       message +=
//           "   السعر:  ر.س${item.unitPrice.toStringAsFixed(2)} × ${item.quantity} =  ر.س${(item.unitPrice * item.quantity).toStringAsFixed(2)}\n";
//     }

//     message += "\n*المجموع الفرعي:*  ر.س${subtotal.toStringAsFixed(2)}\n";
//     message += "*تكلفة الشحن:*  ر.س${shippingCost.toStringAsFixed(2)}\n";
//     message += "*إجمالي المبلغ:*  ر.س${totalAmount.toStringAsFixed(2)}\n";

//     // Encode the message for URL
//     final encodedMessage = Uri.encodeComponent(message);

//     // Replace with your actual WhatsApp number
//     final whatsappNumber =
//         "+201060796400"; // Change this to your business WhatsApp number

//     // Create WhatsApp URL
//     final whatsappUrl = "https://wa.me/$whatsappNumber?text=$encodedMessage";

//     // Launch URL
//     if (await canLaunch(whatsappUrl)) {
//       await launch(whatsappUrl);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('لا يمكن فتح WhatsApp. يرجى التأكد من تثبيت التطبيق.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartItems = cartBox.values.toList();

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         scrolledUnderElevation: 0,
//         leading: const SizedBox(),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_horiz, color: Colors.white),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: _isGuest
//           ? _buildGuestModeView() // عرض واجهة المستخدم للضيف
//           : _buildCartView(cartItems), // عرض واجهة المستخدم للمسجلين
//     );
//   }

//   // واجهة المستخدم للضيف
//   Widget _buildGuestModeView() {
//     return Center(
//       child: Container(
//         margin: const EdgeInsets.all(16),
//         padding: const EdgeInsets.all(24),
//         decoration: BoxDecoration(
//           color: Colors.grey[900],
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: AppColors.primary, width: 1),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.shopping_cart_outlined,
//               size: 64,
//               color: AppColors.primary,
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'وضع الضيف',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'السلة وميزات الشراء متاحة فقط للمستخدمين المسجلين.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white70,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // إعادة تعيين وضع الضيف والانتقال إلى صفحة تسجيل الدخول
//                 GuestModeManager.resetGuestMode().then((_) {
//                   Navigator.of(context).pushNamedAndRemoveUntil(
//                     Routes.loginView,
//                     (route) => false,
//                     arguments: {'fresh_start': true},
//                   );
//                 });
//               },
//               icon: const Icon(Icons.login),
//               label: const Text('تسجيل الدخول للوصول للسلة'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.black,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(vertical: 12),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamedAndRemoveUntil(
//                   Routes.hostView,
//                   (route) => false,
//                 );
//               },
//               child: Text(
//                 'العودة للتصفح',
//                 style: TextStyle(color: AppColors.primary),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // واجهة المستخدم للمسجلين
//   Widget _buildCartView(List<CartItemModel> cartItems) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child:
//           cartItems.isEmpty
//               ? Center(
//                 child: Text(
//                   'السلة فارغة',
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               )
//               : Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       '${cartItems.length} Items',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: cartItems.length,
//                       itemBuilder: (context, index) {
//                         final item = cartItems[index];
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[900],
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 60,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[800],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(
//                                   Icons.book,
//                                   color: AppColors.primary,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item.bookName,
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     Text(
//                                       item.type,
//                                       style: const TextStyle(
//                                         color: Colors.white54,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       ' ر.س${item.unitPrice}',
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(
//                                       Icons.remove,
//                                       color: AppColors.primary,
//                                     ),
//                                     onPressed:
//                                         () => updateQuantity(index, -1),
//                                   ),
//                                   Text(
//                                     '${item.quantity}',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: Icon(
//                                       Icons.add,
//                                       color: AppColors.primary,
//                                     ),
//                                     onPressed: () => updateQuantity(index, 1),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(
//                                       Icons.delete,
//                                       color: Colors.red,
//                                     ),
//                                     onPressed: () => deleteItem(index),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[900],
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Subtotal',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               ' ر.س$subtotal',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Shipping',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             Text(
//                               ' ر.س$shippingCost',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Total amount',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               ' ر.س$totalAmount',
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: sendToWhatsApp,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Checkout via WhatsApp',
//                       style: TextStyle(color: Colors.black, fontSize: 18),
//                     ),
//                   ),
//                 ],
//               ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:united_formation_app/core/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:united_formation_app/features/auth/data/services/guest_mode_manager.dart';
import 'package:united_formation_app/features/auth/ui/widgets/guest_restriction_dialog.dart';
import '../../../../core/themes/app_colors.dart';
import '../../data/cart_model.dart';
import 'order_summary_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Box<CartItemModel> cartBox;
  bool _isGuest = false;

  int shippingCost = 48;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<CartItemModel>('CartBox');
    _checkGuestStatus();
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

  // تعديل وظيفة الإرسال عبر الواتساب مع دعم وضع الضيف
  Future<void> sendToWhatsApp() async {
    // التحقق مما إذا كان المستخدم في وضع الضيف
    if (_isGuest) {
      if (mounted) {
        // عرض مربع حوار القيود إذا كان في وضع الضيف
        await context.checkGuestRestriction(featureName: "الطلب عبر واتساب");
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
    message += "*تفاصيل الطلب:*\n";

    for (int i = 0; i < cartItems.length; i++) {
      final item = cartItems[i];
      message += "${i + 1}. ${item.bookName} (${item.type})\n";
      message +=
          "   السعر:  ر.س${item.unitPrice.toStringAsFixed(2)} × ${item.quantity} =  ر.س${(item.unitPrice * item.quantity).toStringAsFixed(2)}\n";
    }

    message += "\n*المجموع الفرعي:*  ر.س${subtotal.toStringAsFixed(2)}\n";
    message += "*تكلفة الشحن:*  ر.س${shippingCost.toStringAsFixed(2)}\n";
    message += "*إجمالي المبلغ:*  ر.س${totalAmount.toStringAsFixed(2)}\n";

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

  void proceedToSummaryPage() {
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

    // Navigator.of(context).pushNamed(
    //   Routes.orderSummaryView,
    //   arguments: {
    //     'cartItems': cartItems,
    //     'subtotal': subtotal,
    //     'shippingCost': shippingCost,
    //     'totalAmount': totalAmount,
    //   },
    // );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => OrderSummaryPage(
              cartItems: cartItems,
              subtotal: subtotal,
              shippingCost: shippingCost,
              totalAmount: totalAmount,
            ),
      ),
    );
  }

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
          "Shopping Cart",
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: AppColors.text),
            onPressed: () {},
          ),
        ],
      ),
      body:
          _isGuest
              ? _buildGuestModeView() // عرض واجهة المستخدم للضيف
              : _buildCartView(cartItems), // عرض واجهة المستخدم للمسجلين
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
              'وضع الضيف',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'السلة وميزات الشراء متاحة فقط للمستخدمين المسجلين.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // إعادة تعيين وضع الضيف والانتقال إلى صفحة تسجيل الدخول
                GuestModeManager.resetGuestMode().then((_) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.loginView,
                    (route) => false,
                    arguments: {'fresh_start': true},
                  );
                });
              },
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('تسجيل الدخول للوصول للسلة'),
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
                'العودة للتصفح',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
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
                      'السلة فارغة',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ابدأ التسوق لإضافة منتجات إلى سلتك',
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
                      '${cartItems.length} Items',
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
                                      ' ر.س${item.unitPrice}',
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
                                    onPressed: () => updateQuantity(index, -1),
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
                              'Subtotal',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'ر.س $subtotal',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'ر.س $shippingCost',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total amount',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ر.س $totalAmount',
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
                    child: const Text(
                      // 'Checkout via WhatsApp',
                      'Proceed to Checkout',
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
}
