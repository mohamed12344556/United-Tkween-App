import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../data/models/order_model.dart';

class OrderListItem extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const OrderListItem({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.lightGrey,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  order.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  order.customerName,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _formatOrderItems(order.items),
                  style: const TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatOrderItems(List<OrderItem> items) {
    if (items.isEmpty) return '';
    return items.map((item) => item.productName).join(', ');
  }
}
