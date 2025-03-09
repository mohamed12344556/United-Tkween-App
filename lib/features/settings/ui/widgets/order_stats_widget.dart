import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'stat_card_widget.dart';

class OrderStatsWidget extends StatelessWidget {
  final int totalOrders;
  final int pendingOrders;
  final int deliveredOrders;
  final bool isVertical;

  const OrderStatsWidget({
    super.key,
    required this.totalOrders,
    required this.pendingOrders,
    required this.deliveredOrders,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return _buildVerticalLayout(context);
    } else {
      return _buildHorizontalLayout(context);
    }
  }

  Widget _buildHorizontalLayout(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.isTablet ? 20.r : 16.r),
      child: Row(
        children: [
          StatCardWidget(
            title: 'إجمالي الطلبات',
            value: totalOrders.toString(),
            icon: Icons.shopping_bag,
            color: AppColors.primary,
            isResponsive: true, 
          ),
          SizedBox(width: context.isTablet ? 16.w : 12.w), 
          StatCardWidget(
            title: 'قيد التوصيل',
            value: pendingOrders.toString(),
            icon: Icons.local_shipping,
            color: Colors.orange,
            isResponsive: true, 
          ),
          SizedBox(width: context.isTablet ? 16.w : 12.w),
          StatCardWidget(
            title: 'تم التوصيل',
            value: deliveredOrders.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
            isResponsive: true, // إضافة خاصية للتجاوبية
          ),
        ],
      ),
    );
  }

  // التخطيط الرأسي - للوضع الأفقي في الشاشات الكبيرة
  Widget _buildVerticalLayout(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.isTablet ? 20.r : 16.r), // تباعد متجاوب
      child: Column(
        children: [
          StatCardWidget(
            title: 'إجمالي الطلبات',
            value: totalOrders.toString(),
            icon: Icons.shopping_bag,
            color: AppColors.primary,
            isResponsive: true, // إضافة خاصية للتجاوبية
            isVertical: true, // استخدام نسق رأسي في البطاقة
          ),
          SizedBox(height: context.isTablet ? 16.h : 12.h), // مسافة متجاوبة
          StatCardWidget(
            title: 'قيد التوصيل',
            value: pendingOrders.toString(),
            icon: Icons.local_shipping,
            color: Colors.orange,
            isResponsive: true, // إضافة خاصية للتجاوبية
            isVertical: true, // استخدام نسق رأسي في البطاقة
          ),
          SizedBox(height: context.isTablet ? 16.h : 12.h), // مسافة متجاوبة
          StatCardWidget(
            title: 'تم التوصيل',
            value: deliveredOrders.toString(),
            icon: Icons.check_circle,
            color: Colors.green,
            isResponsive: true, // إضافة خاصية للتجاوبية
            isVertical: true, // استخدام نسق رأسي في البطاقة
          ),
        ],
      ),
    );
  }
}