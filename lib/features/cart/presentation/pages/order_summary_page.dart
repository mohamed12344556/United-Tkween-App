import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../data/cart_model.dart';

class OrderSummaryPage extends StatefulWidget {
  final List<CartItemModel> cartItems;
  final int subtotal;
  final int shippingCost;
  final int totalAmount;

  const OrderSummaryPage({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.shippingCost,
    required this.totalAmount,
  });

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  void submitOrder() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم تقديم الطلب بنجاح!')));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الدفع عند الاستلام سيتم بعد استلام الطلب!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'تفاصيل الطلب',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تفاصيل العميل',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppTextField(
                    controller: _nameController,
                    hintText: 'الاسم',
                    labelText: 'الاسم',
                    style: TextStyle(color: Colors.white),
                    fillColor: AppColors.darkSecondary,
                    filled: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  AppTextField(
                    controller: _phoneController,
                    hintText: 'رقم الهاتف',
                    labelText: 'رقم الهاتف',
                    style: TextStyle(color: Colors.white),
                    fillColor: AppColors.darkSecondary,
                    filled: true,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الهاتف';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  AppTextField(
                    controller: _addressController,
                    hintText: 'العنوان',
                    labelText: 'العنوان',
                    style: TextStyle(color: Colors.white),
                    fillColor: AppColors.darkSecondary,
                    filled: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال العنوان';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'تفاصيل الطلب:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children:
                         widget.cartItems.map((item) {
                           return ListTile(
                             title: Text(textAlign: TextAlign.end, item.bookName , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary)),
                             subtitle: Text(
                                 textAlign: TextAlign.end,
                                 'الكمية: ${item.quantity } - السعر: ${item.unitPrice} ر.س',
                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:Colors.black)
                             ),
                           );
                         }).toList(),
                       ),
                     ),
                   ],
                 ),
                  const SizedBox(height: 20),

                  Text('المجموع الفرعي: ${widget.subtotal} ر.س' ,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary)),
                  Text('تكلفة الشحن: ${widget.shippingCost} ر.س',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary)),
                  Text('إجمالي المبلغ: ${widget.totalAmount} ر.س',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary)),
                  const SizedBox(height: 40),

                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: submitOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 90,
                        ),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child:const Text('الدفع عند الاستلام'),
                    ),
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
