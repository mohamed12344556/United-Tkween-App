import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:united_formation_app/features/cart/presentation/logic/purchase_cubit.dart';
import 'package:united_formation_app/features/cart/presentation/logic/purchase_state.dart';

import '../../../../core/core.dart';
import '../../../settings/ui/cubits/profile/profile_cubit.dart';
import '../../../settings/ui/cubits/profile/profile_state.dart';
import '../../data/models/cart_model.dart';
import 'tap_payment_screen.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CreatePurchaseCubit, CreatePurchaseState>(
            listener: (context, state) {
              if (state is CreatePurchaseSuccess) {
                if (state.response.paymentUrl != null) {
                  // يمكن إضافة منطق ما بعد اكتمال الدفع هنا
                  log('Payment URL: ${state.response.paymentUrl}'); 
                  _navigateToPayment(state.response.paymentUrl!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم إنشاء الطلب بنجاح!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              } else if (state is CreatePurchaseError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Details Form
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return _buildLoadingForm();
                    } else if (state.isError) {
                      return Center(
                        child: Text(
                          state.errorMessage ?? 'حدث خطأ ما',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return _buildCustomerForm();
                    }
                  },
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                // Order Details
                _buildOrderDetails(),

                const SizedBox(height: 40),

                // Submit Button
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Widget _buildCustomerForm() {
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
            children: [
              AppTextField(
                controller: _nameController,
                hintText: 'الاسم الكامل',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال الاسم الكامل';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: _phoneController,
                hintText: 'رقم الهاتف',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  if (value.trim().length < 10) {
                    return 'رقم الهاتف يجب أن يكون على الأقل 10 أرقام';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: _addressController,
                hintText: 'العنوان',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
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

  Widget _buildLoadingForm() {
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
  }

  Widget _buildOrderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
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
            border: Border.all(color: Colors.grey.shade300, width: 1),
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
            children:
                widget.cartItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price and quantity
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'الكمية: ${item.quantity}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'السعر: ريال ${item.unitPrice}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Book name
                        Expanded(
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
          ),
        ),

        const SizedBox(height: 24),

        // Order summary
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
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
              _buildSummaryRow('المجموع الفرعي', 'ريال ${widget.subtotal}'),
              const SizedBox(height: 8),
              _buildSummaryRow('تكلفة الشحن', 'ريال ${widget.shippingCost}'),
              const SizedBox(height: 12),
              Divider(color: Colors.grey.shade200),
              const SizedBox(height: 12),
              _buildSummaryRow(
                'إجمالي المبلغ',
                'ريال ${widget.totalAmount}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Align(
      alignment: Alignment.center,
      child: BlocBuilder<CreatePurchaseCubit, CreatePurchaseState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed:
                state is CreatePurchaseLoading ? null : _createPurchaseOrder,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 90),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                state is CreatePurchaseLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'إتمام الطلب',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isTotal ? AppColors.primary : Colors.black,
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isTotal ? AppColors.text : Colors.black,
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _createPurchaseOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final purchaseCubit = context.read<CreatePurchaseCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final profile = profileCubit.state.profile;

    if (widget.cartItems.length == 1) {
      // Single book purchase
      await purchaseCubit.createSingleBookPurchase(
        bookId: widget.cartItems.first.bookId,
        fullName: _nameController.text.trim(),
        email: profile?.email ?? 'default@example.com',
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
    } else {
      // Multiple books purchase
      final bookIds = widget.cartItems.map((item) => item.bookId).toList();
      final quantities = widget.cartItems.map((item) => item.quantity).toList();

      await purchaseCubit.createMultipleBooksPurchase(
        bookIds: bookIds,
        quantities: quantities,
        fullName: _nameController.text.trim(),
        email: profile?.email ?? 'default@example.com',
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );
    }
  }

  Future<void> _loadUserProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    await profileCubit.loadProfile();

    final profile = profileCubit.state.profile;
    if (profile != null) {
      _nameController.text = profile.fullName ?? '';
      _phoneController.text = profile.phoneNumber1 ?? '';
      _addressController.text = profile.address ?? '';
    }
  }

  void _navigateToPayment(String paymentUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TapPaymentScreen(
              tapPaymentUrl: paymentUrl,
              onPaymentComplete: () {
                // يمكن إضافة منطق ما بعد اكتمال الدفع هنا
                Navigator.of(context).popUntil((route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إنشاء الطلب بنجاح!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
      ),
    );
  }
}
