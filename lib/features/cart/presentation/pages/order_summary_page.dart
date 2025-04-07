// import 'package:flutter/material.dart';
// import '../../../../core/themes/app_colors.dart';
// import '../../../../core/widgets/app_text_field.dart';
// import '../../data/cart_model.dart';

// class OrderSummaryPage extends StatefulWidget {
//   final List<CartItemModel> cartItems;
//   final int subtotal;
//   final int shippingCost;
//   final int totalAmount;

//   const OrderSummaryPage({
//     super.key,
//     required this.cartItems,
//     required this.subtotal,
//     required this.shippingCost,
//     required this.totalAmount,
//   });

//   @override
//   State<OrderSummaryPage> createState() => _OrderSummaryPageState();
// }

// class _OrderSummaryPageState extends State<OrderSummaryPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();

//   void submitOrder() {
//     if (_formKey.currentState?.validate() ?? false) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('تم تقديم الطلب بنجاح!')));

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('الدفع عند الاستلام سيتم بعد استلام الطلب!')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
// appBar: AppBar(
//   title: const Text(
//     'تفاصيل الطلب',
//     style: TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//       color: Colors.black,
//     ),
//   ),
//   backgroundColor: Colors.white,
//   iconTheme: const IconThemeData(color: Colors.black),
// ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'تفاصيل العميل',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   AppTextField(
//                     controller: _nameController,
//                     hintText: 'الاسم',
//                     labelText: 'الاسم',
//                     style: TextStyle(color: Colors.white),
//                     fillColor: AppColors.darkSecondary,
//                     filled: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'الرجاء إدخال الاسم';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),

//                   AppTextField(
//                     controller: _phoneController,
//                     hintText: 'رقم الهاتف',
//                     labelText: 'رقم الهاتف',
//                     style: TextStyle(color: Colors.white),
//                     fillColor: AppColors.darkSecondary,
//                     filled: true,
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'الرجاء إدخال رقم الهاتف';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 10),

//                   AppTextField(
//                     controller: _addressController,
//                     hintText: 'العنوان',
//                     labelText: 'العنوان',
//                     style: TextStyle(color: Colors.white),
//                     fillColor: AppColors.darkSecondary,
//                     filled: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'الرجاء إدخال العنوان';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   const Divider(),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'تفاصيل الطلب:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary),
//                   ),
//                   const SizedBox(height: 10),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: [
//                      Expanded(
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children:
//                          widget.cartItems.map((item) {
//                            return ListTile(
//                              title: Text(textAlign: TextAlign.end, item.bookName , style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary)),
//                              subtitle: Text(
//                                  textAlign: TextAlign.end,
//                                  'الكمية: ${item.quantity } - السعر: ${item.unitPrice} ر.س',
//                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:Colors.black)
//                              ),
//                            );
//                          }).toList(),
//                        ),
//                      ),
//                    ],
//                  ),
//                   const SizedBox(height: 20),

//                   Text('المجموع الفرعي: ${widget.subtotal} ر.س' ,
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary)),
//                   Text('تكلفة الشحن: ${widget.shippingCost} ر.س',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary)),
//                   Text('إجمالي المبلغ: ${widget.totalAmount} ر.س',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold ,color:AppColors.primary)),
//                   const SizedBox(height: 40),

//                   Align(
//                     alignment: Alignment.center,
//                     child: ElevatedButton(
//                       onPressed: submitOrder,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 15,
//                           horizontal: 90,
//                         ),
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: Colors.white,
//                       ),
//                       child:const Text('الدفع عند الاستلام'),
//                     ),
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

//!
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/core.dart';
import '../../../settings/domain/entities/profile_entity.dart';
import '../../../settings/ui/cubits/orders/orders_cubit.dart';
import '../../../settings/ui/cubits/profile/profile_cubit.dart';
import '../../../settings/ui/cubits/profile/profile_state.dart';
import '../../data/cart_model.dart';

class OrderSummaryPage extends StatefulWidget {
  final List<CartItemModel>? cartItems;
  final int? subtotal;
  final int? shippingCost;
  final int? totalAmount;
  final ProfileEntity? profile;

  const OrderSummaryPage({
    super.key,
    this.cartItems,
    this.subtotal,
    this.shippingCost,
    this.totalAmount,
    this.profile,
  });

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // void submitOrder() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // إنشاء طلب محاكاة من محتويات السلة
  //     final order = UserOrderEntity(
  //       id: DateTime.now().millisecondsSinceEpoch.toString(),
  //       title: "طلب #${DateTime.now().millisecondsSinceEpoch}",
  //       orderDate: DateTime.now(),
  //       status: OrderStatus.processing,
  //       price: widget.totalAmount.toDouble(),
  //       imageUrl: null,
  //       description: "طلب ${widget.cartItems.length} منتجات",
  //     );

  //     // إظهار رسالة نجاح
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('تم تقديم الطلب بنجاح!')));

  //     // العودة إلى صفحة الطلبات مع تمرير الطلب الجديد
  //     Navigator.of(context).pushNamedAndRemoveUntil(
  //       Routes.ordersView,
  //       (route) => false,
  //       arguments: {'new_order': order},
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    await profileCubit.loadProfile();

    final profile = profileCubit.state.profile;
    if (profile != null) {
      _nameController.text = profile.fullName ?? '';
      _phoneController.text = profile.phoneNumber1 ?? '';
      _addressController.text = profile.address ?? '';
    } else {
      _nameController.clear();
      _phoneController.clear();
      _addressController.clear();
    }
  }

  // void submitOrder() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // إنشاء طلب من محتويات السلة
  //     final order = widget.cartItems!.toOrderEntity(
  //       customerName: _nameController.text,
  //       customerPhone: _phoneController.text,
  //       customerAddress: _addressController.text,
  //       totalAmount: widget.totalAmount!,
  //     );

  //     // إظهار رسالة نجاح
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('تم تقديم الطلب بنجاح!')));

  //     if (context.read<OrdersCubit>() != null) {
  //       await context.read<OrdersCubit>().initialize();
  //     }

  //     // العودة إلى صفحة الطلبات مع تمرير الطلب الجديد
  //     context.pushNamed(Routes.ordersView, arguments: {'new_order': order});
  //   }
  // }
  void submitOrder() async {
    if (_formKey.currentState?.validate() ?? false) {
      final order = widget.cartItems!.toOrderEntity(
        customerName: _nameController.text,
        customerPhone: _phoneController.text,
        customerAddress: _addressController.text,
        totalAmount: widget.totalAmount!,
      );

      await context.read<OrdersCubit>().addLocalOrder(order);

      // انتقل إلى صفحة الطلبات مع تحديث البيانات
      context.pushNamed(Routes.ordersView);
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
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Column(
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }),
                    );
                  } else if (state.isError) {
                    return Center(
                      child: Text(
                        state.errorMessage ?? 'حدث خطأ ما',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return Column(
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
                                // labelText: 'الاسم',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال الاسم';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller:
                                    _phoneController.text == "1111111"
                                        ? TextEditingController()
                                        : _phoneController,
                                hintText: 'رقم الهاتف',
                                // labelText: 'رقم الهاتف',
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
                                controller:
                                    _addressController.text == "Default Address"
                                        ? TextEditingController()
                                        : _addressController,
                                hintText: 'العنوان',
                                // labelText: 'العنوان',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال العنوان';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Header
                  const Text(
                    ':تفاصيل الطلب',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order items
                  Container(
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
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ...widget.cartItems!.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Price and quantity
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'الكمية: ${item.quantity}',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'السعر: ر.س ${item.unitPrice}',
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Book name
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item.bookName,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Order summary - adopting the style from your second example
                  Container(
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
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ر.س ${widget.subtotal}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'المجموع الفرعي',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ر.س ${widget.shippingCost}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'تكلفة الشحن',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
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
                              'ر.س ${widget.totalAmount}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'إجمالي المبلغ',
                              style: TextStyle(
                                color: AppColors.text,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.isLoading ? null : submitOrder,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 90,
                        ),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('الدفع عند الاستلام'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
