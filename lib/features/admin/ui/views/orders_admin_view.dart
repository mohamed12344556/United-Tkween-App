import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/admin/ui/views/order_details_admin_view.dart';
import 'package:united_formation_app/features/admin/ui/views/orders_admin_view.dart';
import 'package:united_formation_app/features/admin/ui/widgets/admin_appbar.dart';
import 'package:united_formation_app/features/admin/ui/widgets/admin_drawer.dart';
import 'package:united_formation_app/features/admin/ui/widgets/error_widget.dart';
import 'package:united_formation_app/features/admin/ui/widgets/loading_widget.dart';
import 'package:united_formation_app/features/admin/ui/widgets/order_list_item.dart';

import '../../../../../core/routes/routes.dart';
import '../../data/models/order_model.dart';
import '../cubits/orders/orders_admin_cubit.dart';

class OrdersAdminView extends StatefulWidget {
  const OrdersAdminView({super.key});

  @override
  State<OrdersAdminView> createState() => _OrdersAdminViewState();
}

class _OrdersAdminViewState extends State<OrdersAdminView> {
  String _selectedFilter = 'جميع الحالات';
  final List<String> _filterOptions = [
    'جميع الحالات',
    'معلقة',
    'قيد المعالجة',
    'مكتملة',
    'ملغية',
  ];

  @override
  void initState() {
    super.initState();
    context.read<OrdersAdminCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBar(title: 'الطلبات'),
      drawer: AdminDrawer(currentRoute: Routes.adminOrdersView),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items:
                  _filterOptions.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedFilter = newValue;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<OrdersAdminCubit, OrdersAdminState>(
              builder: (context, state) {
                if (state is OrdersLoading) {
                  return const LoadingWidget();
                } else if (state is OrdersError) {
                  return ErrorDisplayWidget(
                    message: state.message,
                    onRetry:
                        () => context.read<OrdersAdminCubit>().loadOrders(),
                  );
                } else if (state is OrdersLoaded) {
                  if (state.orders.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد طلبات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  final filteredOrders =
                      _selectedFilter == 'جميع الحالات'
                          ? state.orders
                          : state.orders.where((order) {
                            switch (_selectedFilter) {
                              case 'معلقة':
                                return order.status == OrderStatus.pending;
                              case 'قيد المعالجة':
                                return order.status == OrderStatus.processing;
                              case 'مكتملة':
                                return order.status == OrderStatus.completed;
                              case 'ملغية':
                                return order.status == OrderStatus.cancelled;
                              default:
                                return true;
                            }
                          }).toList();

                  return ListView.builder(
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderListItem(
                        order: order,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      OrderDetailsAdminView(orderId: order.id),
                            ),
                          );
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
    );
  }
}
