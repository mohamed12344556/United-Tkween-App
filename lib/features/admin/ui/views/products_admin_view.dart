import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/core/utilities/extensions.dart';
import '../../../../core/themes/app_colors.dart';
import '../cubits/products/products_admin_cubit.dart';
import '../widgets/admin_appbar.dart';
import '../widgets/admin_drawer.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_list_item.dart';
import '../../../../core/routes/routes.dart';
import '../../data/models/product_model.dart';

class ProductsAdminView extends StatefulWidget {
  const ProductsAdminView({super.key});

  @override
  State<ProductsAdminView> createState() => _ProductsAdminViewState();
}

class _ProductsAdminViewState extends State<ProductsAdminView> {
  String _searchQuery = '';
  String _selectedCategory = 'جميع الأقسام';
  final List<String> _categories = [
    'جميع الأقسام',
    'كتب التنمية',
    'الكتب الأدبية',
    'كتب علمية',
    'كتب دينية',
    'قصص وروايات',
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProductsAdminCubit>().loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'المنتجات الحالية'),
      drawer: const AdminDrawer(currentRoute: Routes.adminProductsView),
      body: Column(
        children: [
          _buildSearchAndFilterSection(),
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
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  // تطبيق الفلتر والبحث
                  final filteredProducts = _filterProducts(state.products);

                  if (filteredProducts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد منتجات تطابق معايير البحث',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _selectedCategory = 'جميع الأقسام';
                                _searchController.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('إعادة ضبط الفلتر'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ProductListItem(
                          product: product,
                          onEdit: () {
                            context.pushNamed(
                              Routes.adminEditProductView,
                              arguments: product,
                            );
                          },
                          onDelete: () {
                            _showDeleteConfirmationDialog(context, product.id);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      'حدث خطأ غير متوقع',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.pushNamed(Routes.adminAddProductView);
        },
        backgroundColor: AppColors.primary,
        icon: Icon(Icons.add, color: AppColors.darkBackground),
        label: const Text(
          'إضافة منتج',
          style: TextStyle(
            color: AppColors.darkBackground,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    double spacing = 12;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: spacing,
        children: [
          // رقم إحصائيات
          BlocBuilder<ProductsAdminCubit, ProductsAdminState>(
            builder: (context, state) {
              if (state is ProductsLoaded) {
                final filteredProducts = _filterProducts(state.products);
                final totalValue = filteredProducts.fold(
                  0.0,
                  (sum, product) => sum + (product.price * product.quantity),
                );
                // return Container(
                //   padding: const EdgeInsets.symmetric(vertical: 20),
                //   decoration: BoxDecoration(
                //     // color: Colors.red.shade900.withOpacity(0.3),
                //     color: AppColors.lightGrey,
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(color: AppColors.primary, width: 1.5),
                //     boxShadow: const [
                //       BoxShadow(
                //         color: Colors.black26,
                //         offset: Offset(0, 2),
                //         blurRadius: 4,
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       _buildStatCard(
                //         icon: Icons.inventory_2,
                //         title: 'عدد المنتجات',
                //         value: '${filteredProducts.length}',
                //       ),
                //       const VerticalDivider(color: Colors.red, thickness: 1),
                //       _buildStatCard(
                //         icon: Icons.shopping_bag,
                //         title: 'إجمالي الكمية',
                //         value:
                //             '${filteredProducts.fold(0, (sum, p) => sum + p.quantity)}',
                //       ),
                //       const VerticalDivider(color: Colors.red, thickness: 1),
                //       _buildStatCard(
                //         icon: Icons.attach_money,
                //         title: 'إجمالي القيمة',
                //         value: '${totalValue.toStringAsFixed(2)} جنيه',
                //       ),
                //     ],
                //   ),
                // );

                return Card(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          border: Border.all(color: Colors.white, width: 1.3),
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              color: AppColors.primary,
                              size: 25,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  filteredProducts.length.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  ' : عدد المنتجات',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
          // البحث
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'البحث عن منتج...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon:
                  _searchQuery.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[800],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          // الفلتر حسب القسم
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCategory,
                icon: const Icon(Icons.filter_list, color: Colors.red),
                dropdownColor: Colors.grey[800],
                style: const TextStyle(color: Colors.white),
                hint: const Text(
                  'تصفية حسب القسم',
                  style: TextStyle(color: Colors.grey),
                ),
                items:
                    _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    // return Card(
    //   child: Row(
    //     children: [
    //       Container(
    //         padding: const EdgeInsets.all(16),
    //         decoration: BoxDecoration(
    //           color: AppColors.lightGrey,
    //           border: Border.all(color: AppColors.primary, width: 1.3),
    //           borderRadius: BorderRadius.circular(8),
    //         ),

    //         child: Column(
    //           children: [
    //             Icon(Icons.shopping_bag, color: Colors.white, size: 25),
    //             const SizedBox(height: 5),
    //             Text('عدد المنتجات', style: TextStyle(color: Colors.white)),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.red, size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  List<ProductModel> _filterProducts(List<ProductModel> products) {
    return products.where((product) {
      // تطبيق فلتر البحث
      final matchesSearch =
          _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (product.description?.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ??
              false);

      // تطبيق فلتر القسم
      final matchesCategory =
          _selectedCategory == 'جميع الأقسام' ||
          product.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
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
          backgroundColor: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.delete, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text('تأكيد الحذف', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: const Text(
            'هل أنت متأكد من حذف هذا المنتج؟ هذا الإجراء لا يمكن التراجع عنه.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('حذف'),
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
