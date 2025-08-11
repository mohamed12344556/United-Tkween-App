import 'package:flutter/material.dart';
import 'package:united_formation_app/generated/l10n.dart';
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
            title: S.of(context).total_orders,
            value: totalOrders.toString(),
            icon: Icons.shopping_bag,
            color: AppColors.primary,
            isResponsive: true, 
          ),
          SizedBox(width: context.isTablet ? 16.w : 12.w), 
          StatCardWidget(
            title: S.of(context).pending_orders,
            value: pendingOrders.toString(),
            icon: Icons.local_shipping,
            color: Colors.orange,  // استخدام اللون البرتقالي كما كان
            isResponsive: true, 
          ),
          SizedBox(width: context.isTablet ? 16.w : 12.w),
          StatCardWidget(
            title: S.of(context).delivered_orders,
            value: deliveredOrders.toString(),
            icon: Icons.check_circle,
            color: AppColors.success,
            isResponsive: true,
          ),
        ],
      ),
    );
  }

  // التخطيط الرأسي - للوضع الأفقي في الشاشات الكبيرة
  Widget _buildVerticalLayout(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.isTablet ? 20.r : 16.r),
      child: Column(
        children: [
          StatCardWidget(
            title: S.of(context).total_orders,
            value: totalOrders.toString(),
            icon: Icons.shopping_bag,
            color: AppColors.primary,
            isResponsive: true,
            isVertical: true,
          ),
          SizedBox(height: context.isTablet ? 16.h : 12.h),
          StatCardWidget(
            title: S.of(context).pending_orders,
            value: pendingOrders.toString(),
            icon: Icons.local_shipping,
            color: Colors.orange,  // استخدام اللون البرتقالي كما كان
            isResponsive: true,
            isVertical: true,
          ),
          SizedBox(height: context.isTablet ? 16.h : 12.h),
          StatCardWidget(
            title: S.of(context).delivered_orders,
            value: deliveredOrders.toString(),
            icon: Icons.check_circle,
            color: AppColors.success,
            isResponsive: true,
            isVertical: true,
          ),
        ],
      ),
    );
  }
}