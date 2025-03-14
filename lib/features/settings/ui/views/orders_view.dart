import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/settings/ui/widgets/empty_state_widget.dart';

import '../../../../core/core.dart';
import '../cubits/orders/orders_cubit.dart';
import '../cubits/orders/orders_state.dart';
import '../widgets/order_item_card.dart';
import '../widgets/order_stats_widget.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    // تهيئة الأحجام المتجاوبة
    context.initResponsive();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      title: Text(
        'مشترياتي',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: context.isTablet ? 20.sp : 18.sp, // حجم خط متجاوب
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarHeight: context.isTablet ? 64.h : 56.h, // ارتفاع متجاوب
      actions: [
        IconButton(
          icon: Container(
            padding: 8.paddingAll,
            decoration: BoxDecoration(
              color: AppColors.darkSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.filter_list,
              color: AppColors.primary,
              size: context.isTablet ? 24.r : 20.r, // حجم أيقونة متجاوب
            ),
          ),
          onPressed: () {
            // TODO: تنفيذ الفلترة
          },
        ),
        SizedBox(width: 8.w), // مسافة متجاوبة
      ],
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  Widget _buildBody() {
    // إذا كان في وضع أفقي وعلى جهاز كبير، استخدم تخطيط مختلف
    if (context.isLandscape && (context.isTablet || context.isDesktop)) {
      return _buildLandscapeLayout();
    }

    // التخطيط العمودي الافتراضي
    return Column(
      children: [
        // استخدام الإحصائيات المتجاوبة
        const OrderStatsWidget(
          totalOrders: 14,
          pendingOrders: 3,
          deliveredOrders: 9,
        ),
        Expanded(child: _buildOrdersList()),
      ],
    );
  }

  // تخطيط للوضع الأفقي على الأجهزة الكبيرة
  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        // جزء للإحصائيات - على الجانب
        SizedBox(
          width: context.screenWidth * 0.25, // 25% من عرض الشاشة
          child: Column(
            children: [
              SizedBox(height: 16.h),
              Text(
                'ملخص الطلبات',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 16.h),
              const Expanded(
                child: OrderStatsWidget(
                  totalOrders: 14,
                  pendingOrders: 3,
                  deliveredOrders: 9,
                  isVertical: true, // تعديل المكون ليدعم الاتجاه الرأسي
                ),
              ),
            ],
          ),
        ),

        // خط فاصل
        Container(width: 1, color: Colors.grey[800]),

        // جزء لقائمة الطلبات
        Expanded(flex: 3, child: _buildOrdersList()),
      ],
    );
  }

  Widget _buildOrdersList() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.isLoading && !state.hasOrders) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.secondary.withValues(alpha: 51),
              strokeWidth: context.isTablet ? 3.0 : 2.0, // سمك متجاوب
            ),
          );
        }

        if (state.isError && !state.hasOrders) {
          return _buildErrorState(state);
        }

        if (!state.hasOrders) {
          return _buildEmptyState();
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
            padding: EdgeInsets.all(
              context.isTablet ? 20.r : 16.r,
            ), // تباعد متجاوب
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return OrderItemCard(
                order: order,
                onTap: () {},
                isResponsive: true, // إضافة خاصية للتجاوبية في المكون
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(OrdersState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: context.isTablet ? 70.r : 60.r, // حجم متجاوب للأيقونة
            color: AppColors.error,
          ),
          SizedBox(height: 16.h), // مسافة متجاوبة
          Text(
            state.errorMessage ?? 'خطأ في تحميل المشتريات',
            style: TextStyle(
              color: Colors.white,
              fontSize: context.isTablet ? 18.sp : 16.sp, // حجم خط متجاوب
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h), // مسافة متجاوبة
          SizedBox(
            width: context.isTablet ? 240.w : 200.w, // عرض متجاوب
            height: context.isTablet ? 54.h : 48.h, // ارتفاع متجاوب
            child: ElevatedButton.icon(
              onPressed: () => context.read<OrdersCubit>().loadOrders(),
              icon: Icon(
                Icons.refresh,
                size: context.isTablet ? 20.r : 16.r, // حجم متجاوب للأيقونة
              ),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontSize: context.isTablet ? 16.sp : 14.sp, // حجم خط متجاوب
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    50.r,
                  ), // نصف قطر حافة متجاوب
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h), // تباعد متجاوب
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
      icon: Icons.shopping_cart_outlined,
      title: 'لا توجد مشتريات حالياً',
      message: 'ابدأ بالتسوق واستمتع بمنتجاتنا المميزة',
      buttonText: 'تسوق الآن',
      onButtonPressed: () {},
      iconColor: AppColors.primary,
      iconSize: context.isTablet ? 70.r : 50.r, // حجم متجاوب للأيقونة
      titleSize: context.isTablet ? 24.sp : 20.sp, // حجم خط متجاوب للعنوان
      messageSize: context.isTablet ? 18.sp : 16.sp, // حجم خط متجاوب للرسالة
      buttonWidth: context.isTablet ? 240.w : 200.w, // عرض زر متجاوب
    );
  }
}
