import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/settings/ui/widgets/empty_state_widget.dart';

import '../../../../core/core.dart';
import '../cubits/orders/orders_cubit.dart';
import '../cubits/orders/orders_state.dart';
import '../widgets/order_item_card.dart';
import '../widgets/order_stats_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'مشترياتي',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.darkSecondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.filter_list,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            onPressed: () {
              // TODO: تنفيذ الفلترة
            },
          ),
          const SizedBox(width: 8),
        ],
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Column(
        children: [
          const OrderStatsWidget(
            totalOrders: 14,
            pendingOrders: 3,
            deliveredOrders: 9,
          ),
          Expanded(
            child: BlocBuilder<OrdersCubit, OrdersState>(
              builder: (context, state) {
                if (state.isLoading && !state.hasOrders) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      backgroundColor: AppColors.secondary.withValues(
                        alpha: 51,
                      ), // 0.2
                    ),
                  );
                }

                if (state.isError && !state.hasOrders) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.errorMessage ?? 'خطأ في تحميل المشتريات',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton.icon(
                            onPressed:
                                () => context.read<OrdersCubit>().loadOrders(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('إعادة المحاولة'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!state.hasOrders) {
                  return EmptyStateWidget(
                    icon: Icons.shopping_cart_outlined,
                    title: 'لا توجد مشتريات حالياً',
                    message: 'ابدأ بالتسوق واستمتع بمنتجاتنا المميزة',
                    buttonText: 'تسوق الآن',
                    onButtonPressed: () {},
                    iconColor: AppColors.primary,
                  );
                }

                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: AppColors.primary,
                  backgroundColor: AppColors.darkSurface,
                  onRefresh: () async {
                    if (mounted) {
                      await context.read<OrdersCubit>().loadOrders();
                    }
                  },
                  child: ListView.builder(
                    key: const PageStorageKey('orders_list'),
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) {
                      final order = state.orders[index];
                      return OrderItemCard(order: order, onTap: () {});
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
