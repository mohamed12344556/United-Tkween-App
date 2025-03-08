import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'stat_card_widget.dart';

class OrderStatsWidget extends StatelessWidget {
  final int totalOrders;
  final int pendingOrders;
  final int deliveredOrders;

  const OrderStatsWidget({
    super.key,
    required this.totalOrders,
    required this.pendingOrders,
    required this.deliveredOrders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          StatCardWidget(
            title: 'إجمالي الطلبات',
            value: totalOrders.toString(),
            icon: Icons.shopping_bag,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          StatCardWidget(
            title: 'قيد التوصيل',
            value: pendingOrders.toString(),
            icon: Icons.local_shipping,
            color: Colors.orange,
          ),
          const SizedBox(width: 12),
          StatCardWidget(
            title: 'تم التوصيل',
            value: deliveredOrders.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}