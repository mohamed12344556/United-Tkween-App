import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_order_entity.dart';

class OrderItemCard extends StatelessWidget {
  final UserOrderEntity order;
  final VoidCallback? onTap;

  const OrderItemCard({
    Key? key,
    required this.order,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderHeader(context),
              _buildOrderDetails(context),
              _buildOrderFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Stack(
      children: [
        // Product Image
        SizedBox(
          height: 140,
          width: double.infinity,
          child: order.imageUrl != null
              ? Image.network(
                  order.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.darkSecondary,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: AppColors.darkSecondary,
                  child: const Center(
                    child: Icon(
                      Icons.book,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                ),
        ),
        
        // Date badge
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  order.formattedDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Status badge
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getStatusColor(order.status).withOpacity(0.9),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              order.statusText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        // Price tag
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
              ),
            ),
            child: Text(
              '${order.price.toStringAsFixed(0)} ج.م',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            order.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          if (order.description != null) ...[
            const SizedBox(height: 8),
            Text(
              order.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderFooter(BuildContext context) {
    final isDelivered = order.status == OrderStatus.delivered;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkBackground.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(order.status),
            size: 20,
            color: _getStatusColor(order.status),
          ),
          const SizedBox(width: 8),
          Text(
            _getStatusMessage(order.status),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[300],
            ),
          ),
          const Spacer(),
          if (isDelivered)
            OutlinedButton.icon(
              onPressed: () {
                // TODO: تنفيذ التحميل
              },
              icon: const Icon(Icons.download, size: 16),
              label: const Text('تحميل'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                minimumSize: const Size(0, 36),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: () {
                // TODO: تنفيذ التتبع
              },
              icon: const Icon(Icons.location_on, size: 16),
              label: const Text('تتبع'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _getStatusColor(order.status),
                side: BorderSide(color: _getStatusColor(order.status), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                minimumSize: const Size(0, 36),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.orange;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }
  
  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Icons.hourglass_bottom;
      case OrderStatus.shipped:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }
  
  String _getStatusMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'جاري تجهيز طلبك';
      case OrderStatus.shipped:
        return 'طلبك في الطريق إليك';
      case OrderStatus.delivered:
        return 'تم توصيل طلبك بنجاح';
      case OrderStatus.cancelled:
        return 'تم إلغاء الطلب';
    }
  }
}