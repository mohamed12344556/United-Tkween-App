import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/admin/ui/views/add_product_admin_view.dart';
import 'package:united_formation_app/features/admin/ui/views/edit_product_admin_view.dart';
import '../cubits/products/products_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_list_item.dart';
import '../../../../core/routes/routes.dart';

class ProductsAdminView extends StatefulWidget {
  const ProductsAdminView({super.key});

  @override
  State<ProductsAdminView> createState() => _ProductsAdminViewState();
}

class _ProductsAdminViewState extends State<ProductsAdminView> {
  @override
  void initState() {
    super.initState();
    context.read<ProductsAdminCubit>().loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'المنتجات الحالية'),
      drawer: const AdminDrawer(currentRoute: Routes.libraryView),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ProductsAdminCubit, ProductsAdminState>(
              builder: (context, state) {
                if (state is ProductsLoading) {
                  return const LoadingWidget();
                } else if (state is ProductsError) {
                  return ErrorDisplayWidget(
                    message: state.message,
                    onRetry:
                        () => context.read<ProductsAdminCubit>().loadProducts(),
                  );
                } else if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد منتجات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductListItem(
                        product: product,
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EditProductAdminView(product: product),
                            ),
                          );
                        },
                        onDelete: () {
                          _showDeleteConfirmationDialog(context, product.id);
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('حدث خطأ غير متوقع'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductAdminView()),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String productId,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('حذف', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ProductsAdminCubit>().deleteProduct(productId);
              },
            ),
          ],
        );
      },
    );
  }
}
