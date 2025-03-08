// file: lib/features/profile/ui/screens/orders_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/profile/ui/widgets/content_container.dart';
import 'package:united_formation_app/features/profile/ui/widgets/empty_state_widget.dart';
import 'package:united_formation_app/features/profile/ui/widgets/error_retry_widget.dart';
import 'package:united_formation_app/features/profile/ui/widgets/order_item_card.dart';
import '../../../../core/core.dart';
import '../cubits/orders/orders_cubit.dart';
import '../cubits/orders/orders_state.dart';

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
    // تحميل المشتريات عند فتح الصفحة
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          context.isDarkMode ? AppColors.darkBackground : Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.secondary),
        title: const Text(
          'مشترياتي',
          style: TextStyle(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.isLoading && !state.hasOrders) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state.isError && !state.hasOrders) {
            return ErrorRetryWidget(
              message: state.errorMessage ?? 'خطأ في تحميل المشتريات',
              onRetry: () => context.read<OrdersCubit>().loadOrders(),
            );
          }

          if (!state.hasOrders) {
            return EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              message: 'لا توجد مشتريات حالياً',
            );
          }

          return ContentContainer(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              color: AppColors.secondary,
              backgroundColor: AppColors.primary,
              onRefresh: () async {
                await context.read<OrdersCubit>().loadOrders();
              },
              child: AnimatedList(
                key: const PageStorageKey('orders_list'),
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                initialItemCount: state.orders.length,
                itemBuilder: (context, index, animation) {
                  final order = state.orders[index];
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(Tween<Offset>(
                        begin: const Offset(0.5, 0),
                        end: Offset.zero,
                      )),
                      child: OrderItemCard(order: order),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}