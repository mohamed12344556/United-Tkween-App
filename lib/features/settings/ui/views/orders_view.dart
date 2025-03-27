// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:united_formation_app/features/settings/ui/widgets/empty_state_widget.dart';

// import '../../../../core/core.dart';
// import '../../domain/entities/user_order_entity.dart';
// import '../cubits/orders/orders_cubit.dart';
// import '../cubits/orders/orders_state.dart';
// import '../widgets/order_item_card.dart';
// import '../widgets/order_stats_widget.dart';

// class OrdersView extends StatefulWidget {
//   const OrdersView({super.key});

//   @override
//   State<OrdersView> createState() => _OrdersViewState();
// }

// class _OrdersViewState extends State<OrdersView> {
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       GlobalKey<RefreshIndicatorState>();

//   @override
//   void initState() {
//     super.initState();
//     context.read<OrdersCubit>().loadOrders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // تهيئة الأحجام المتجاوبة
//     context.initResponsive();

//     return Scaffold(
//       backgroundColor: AppColors.darkBackground,
//       appBar: _buildAppBar(),
//       body: _buildBody(),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: true,
//       scrolledUnderElevation: 0,
//       title: Text(
//         'مشترياتي',
//         style: TextStyle(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//           fontSize: context.isTablet ? 20.sp : 18.sp, // حجم خط متجاوب
//         ),
//       ),
//       iconTheme: const IconThemeData(color: Colors.white),
//       toolbarHeight: context.isTablet ? 64.h : 56.h, // ارتفاع متجاوب
//       actions: [
//         IconButton(
//           icon: Container(
//             padding: 8.paddingAll,
//             decoration: BoxDecoration(
//               color: AppColors.lightGrey,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.filter_list,
//               color:
//                   context.read<OrdersCubit>().state.isFiltered
//                       ? AppColors.primary.withOpacity(0.7)
//                       : AppColors.primary,
//               size: context.isTablet ? 24.r : 20.r,
//             ),
//           ),
//           onPressed: () {
//             _showFilterBottomSheet(context);
//           },
//         ),
//         SizedBox(width: 8.w), // مسافة متجاوبة
//       ],
//       leading: IconButton(
//         onPressed: () => context.pop(),
//         icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return BlocBuilder<OrdersCubit, OrdersState>(
//       builder: (context, state) {
//         // حساب الإحصائيات من بيانات الطلبات الفعلية
//         int totalOrders = state.orders.length;
//         int pendingOrders =
//             state.orders
//                 .where(
//                   (order) =>
//                       order.status == OrderStatus.processing ||
//                       order.status == OrderStatus.shipped,
//                 )
//                 .length;
//         int deliveredOrders =
//             state.orders
//                 .where((order) => order.status == OrderStatus.delivered)
//                 .length;

//         // إذا كان في وضع أفقي وعلى جهاز كبير، استخدم تخطيط مختلف
//         if (context.isLandscape && (context.isTablet || context.isDesktop)) {
//           return _buildLandscapeLayout(
//             totalOrders,
//             pendingOrders,
//             deliveredOrders,
//           );
//         }

//         // التخطيط العمودي الافتراضي
//         return Column(
//           children: [
//             // استخدام الإحصائيات المتجاوبة بالقيم الفعلية
//             OrderStatsWidget(
//               totalOrders: totalOrders,
//               pendingOrders: pendingOrders,
//               deliveredOrders: deliveredOrders,
//             ),
//             Expanded(child: _buildOrdersList()),
//           ],
//         );
//       },
//     );
//   }

//   // تعديل التخطيط الأفقي ليستخدم الإحصائيات الفعلية
//   Widget _buildLandscapeLayout(
//     int totalOrders,
//     int pendingOrders,
//     int deliveredOrders,
//   ) {
//     return Row(
//       children: [
//         // جزء للإحصائيات - على الجانب
//         SizedBox(
//           width: context.screenWidth * 0.25, // 25% من عرض الشاشة
//           child: Column(
//             children: [
//               SizedBox(height: 16.h),
//               Text(
//                 'ملخص الطلبات',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18.sp,
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Expanded(
//                 child: OrderStatsWidget(
//                   totalOrders: totalOrders,
//                   pendingOrders: pendingOrders,
//                   deliveredOrders: deliveredOrders,
//                   isVertical: true, // تعديل المكون ليدعم الاتجاه الرأسي
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // خط فاصل
//         Container(width: 1, color: Colors.grey[800]),

//         // جزء لقائمة الطلبات
//         Expanded(flex: 3, child: _buildOrdersList()),
//       ],
//     );
//   }

//   Widget _buildOrdersList() {
//     return BlocBuilder<OrdersCubit, OrdersState>(
//       builder: (context, state) {
//         if (state.isLoading && !state.hasOrders) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: AppColors.primary,
//               backgroundColor: AppColors.secondary.withValues(alpha: 51),
//               strokeWidth: context.isTablet ? 3.0 : 2.0,
//             ),
//           );
//         }

//         if (state.isError && !state.hasOrders) {
//           return _buildErrorState(state);
//         }

//         if (!state.hasOrders) {
//           // عرض رسالة مختلفة إذا كان هناك طلبات ولكن الفلتر لم يُظهر أي منها
//           if (state.isFiltered && state.orders.isNotEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.filter_list_off,
//                     size: 60.r,
//                     color: Colors.grey[400],
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     'لا توجد طلبات تطابق الفلتر المحدد',
//                     style: TextStyle(color: Colors.white, fontSize: 16.sp),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 16.h),
//                   TextButton.icon(
//                     onPressed: () {
//                       context.read<OrdersCubit>().clearFilter();
//                     },
//                     icon: Icon(Icons.filter_list_off, size: 18.r),
//                     label: Text(
//                       'إزالة الفلتر',
//                       style: TextStyle(fontSize: 14.sp),
//                     ),
//                     style: TextButton.styleFrom(
//                       foregroundColor: AppColors.primary,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return _buildEmptyState();
//         }

//         return RefreshIndicator(
//           key: _refreshIndicatorKey,
//           color: AppColors.primary,
//           backgroundColor: AppColors.darkSurface,
//           onRefresh: () async {
//             if (mounted) {
//               await context.read<OrdersCubit>().loadOrders();
//             }
//           },
//           child: ListView.builder(
//             key: const PageStorageKey('orders_list'),
//             padding: EdgeInsets.all(context.isTablet ? 20.r : 16.r),
//             physics: const BouncingScrollPhysics(
//               parent: AlwaysScrollableScrollPhysics(),
//             ),
//             itemCount: state.filteredOrders.length,
//             itemBuilder: (context, index) {
//               final order = state.filteredOrders[index];
//               return OrderItemCard(
//                 order: order,
//                 onTap: () {},
//                 isResponsive: true,
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildErrorState(OrdersState state) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: context.isTablet ? 70.r : 60.r, // حجم متجاوب للأيقونة
//             color: AppColors.error,
//           ),
//           SizedBox(height: 16.h), // مسافة متجاوبة
//           Text(
//             state.errorMessage ?? 'خطأ في تحميل المشتريات',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: context.isTablet ? 18.sp : 16.sp, // حجم خط متجاوب
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 24.h), // مسافة متجاوبة
//           SizedBox(
//             width: context.isTablet ? 240.w : 200.w, // عرض متجاوب
//             height: context.isTablet ? 54.h : 48.h, // ارتفاع متجاوب
//             child: ElevatedButton.icon(
//               // onPressed: () => context.read<OrdersCubit>().loadOrders(),
//               onPressed: () {
//                 // تحقق إذا كانت الرسالة تحتوي على كلمة توكن أو token
//                 if (state.errorMessage?.toLowerCase().contains('توكن') ==
//                         true ||
//                     state.errorMessage?.toLowerCase().contains('token') ==
//                         true) {
//                   // إذا كان خطأ متعلق بالتوكن، انتقل إلى صفحة تسجيل الدخول
//                   context.pushNamedAndRemoveUntil(
//                     Routes.loginView,
//                     predicate: (route) => false,
//                     arguments: {'fresh_start': true},
//                   );
//                 } else {
//                   // وإلا حاول إعادة تحميل البيانات
//                   context.read<OrdersCubit>().loadOrders();
//                 }
//               },
//               icon: Icon(
//                 Icons.refresh,
//                 size: context.isTablet ? 20.r : 16.r, // حجم متجاوب للأيقونة
//               ),
//               label: Text(
//                 'إعادة المحاولة',
//                 style: TextStyle(
//                   fontSize: context.isTablet ? 16.sp : 14.sp, // حجم خط متجاوب
//                 ),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: AppColors.secondary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(
//                     50.r,
//                   ), // نصف قطر حافة متجاوب
//                 ),
//                 padding: EdgeInsets.symmetric(vertical: 12.h), // تباعد متجاوب
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return EmptyStateWidget(
//       icon: Icons.shopping_cart_outlined,
//       title: 'لا توجد مشتريات حالياً',
//       message: 'ابدأ بالتسوق واستمتع بمنتجاتنا المميزة',
//       buttonText: 'تسوق الآن',
//       onButtonPressed: () {
//         context.pushNamedAndRemoveUntil(
//           Routes.hostView,
//           predicate: (route) => false,
//         );
//       },
//       iconColor: AppColors.primary,
//       iconSize: context.isTablet ? 70.r : 50.r, // حجم متجاوب للأيقونة
//       titleSize: context.isTablet ? 24.sp : 20.sp, // حجم خط متجاوب للعنوان
//       messageSize: context.isTablet ? 18.sp : 16.sp, // حجم خط متجاوب للرسالة
//       buttonWidth: context.isTablet ? 240.w : 200.w, // عرض زر متجاوب
//     );
//   }

//   // دالة لعرض مربع حوار التصفية
//   void _showFilterBottomSheet(BuildContext context) {
//     final ordersCubit = context.read<OrdersCubit>();
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: AppColors.darkSurface,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//       ),
//       builder: (bottomSheetContext) {
//         // نوفر نفس الـ cubit داخل الـ BottomSheet
//         return BlocProvider.value(
//           value: ordersCubit,
//           child: BlocBuilder<OrdersCubit, OrdersState>(
//             builder: (context, state) {
//               return Padding(
//                 padding: EdgeInsets.all(20.r),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'تصفية الطلبات',
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(height: 20.h),

//                     // خيارات التصفية
//                     _buildFilterOption(
//                       context,
//                       title: 'جميع الطلبات',
//                       isSelected: state.filterStatus == null,
//                       onTap: () {
//                         context.read<OrdersCubit>().clearFilter();
//                         Navigator.pop(bottomSheetContext);
//                       },
//                     ),
//                     _buildFilterOption(
//                       context,
//                       title: 'قيد المعالجة',
//                       isSelected: state.filterStatus == OrderStatus.processing,
//                       onTap: () {
//                         context.read<OrdersCubit>().setFilter(
//                           OrderStatus.processing,
//                         );
//                         Navigator.pop(context);
//                       },
//                     ),

//                     _buildFilterOption(
//                       context,
//                       title: 'تم الشحن',
//                       isSelected: state.filterStatus == OrderStatus.shipped,
//                       onTap: () {
//                         context.read<OrdersCubit>().setFilter(
//                           OrderStatus.shipped,
//                         );
//                         Navigator.pop(context);
//                       },
//                     ),

//                     _buildFilterOption(
//                       context,
//                       title: 'تم التسليم',
//                       isSelected: state.filterStatus == OrderStatus.delivered,
//                       onTap: () {
//                         context.read<OrdersCubit>().setFilter(
//                           OrderStatus.delivered,
//                         );
//                         Navigator.pop(context);
//                       },
//                     ),

//                     _buildFilterOption(
//                       context,
//                       title: 'ملغي',
//                       isSelected: state.filterStatus == OrderStatus.cancelled,
//                       onTap: () {
//                         context.read<OrdersCubit>().setFilter(
//                           OrderStatus.cancelled,
//                         );
//                         Navigator.pop(context);
//                       },
//                     ),

//                     SizedBox(height: 16.h),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFilterOption(
//     BuildContext context, {
//     required String title,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
//         margin: EdgeInsets.only(bottom: 8.h),
//         decoration: BoxDecoration(
//           color:
//               isSelected
//                   ? AppColors.primary.withOpacity(0.2)
//                   : Colors.transparent,
//           borderRadius: BorderRadius.circular(10.r),
//           border: Border.all(
//             color: isSelected ? AppColors.primary : Colors.grey[700]!,
//             width: 1.r,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 color: isSelected ? AppColors.primary : Colors.white,
//                 fontSize: 16.sp,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//             if (isSelected)
//               Icon(Icons.check_circle, color: AppColors.primary, size: 20.r),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/settings/ui/widgets/empty_state_widget.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_order_entity.dart';
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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      title: Text(
        'مشترياتي',
        style: TextStyle(
          color: Colors.black,
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
              color: AppColors.lightGrey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.filter_list,
              color:
                  context.read<OrdersCubit>().state.isFiltered
                      ? AppColors.primary.withOpacity(0.7)
                      : AppColors.primary,
              size: context.isTablet ? 24.r : 20.r,
            ),
          ),
          onPressed: () {
            _showFilterBottomSheet(context);
          },
        ),
        SizedBox(width: 8.w), // مسافة متجاوبة
      ],
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        // حساب الإحصائيات من بيانات الطلبات الفعلية
        int totalOrders = state.orders.length;
        int pendingOrders =
            state.orders
                .where(
                  (order) =>
                      order.status == OrderStatus.processing ||
                      order.status == OrderStatus.shipped,
                )
                .length;
        int deliveredOrders =
            state.orders
                .where((order) => order.status == OrderStatus.delivered)
                .length;

        // إذا كان في وضع أفقي وعلى جهاز كبير، استخدم تخطيط مختلف
        if (context.isLandscape && (context.isTablet || context.isDesktop)) {
          return _buildLandscapeLayout(
            totalOrders,
            pendingOrders,
            deliveredOrders,
          );
        }

        // التخطيط العمودي الافتراضي
        return Column(
          children: [
            // استخدام الإحصائيات المتجاوبة بالقيم الفعلية
            OrderStatsWidget(
              totalOrders: totalOrders,
              pendingOrders: pendingOrders,
              deliveredOrders: deliveredOrders,
            ),
            Expanded(child: _buildOrdersList()),
          ],
        );
      },
    );
  }

  // تعديل التخطيط الأفقي ليستخدم الإحصائيات الفعلية
  Widget _buildLandscapeLayout(
    int totalOrders,
    int pendingOrders,
    int deliveredOrders,
  ) {
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
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: OrderStatsWidget(
                  totalOrders: totalOrders,
                  pendingOrders: pendingOrders,
                  deliveredOrders: deliveredOrders,
                  isVertical: true, // تعديل المكون ليدعم الاتجاه الرأسي
                ),
              ),
            ],
          ),
        ),

        // خط فاصل
        Container(width: 1, color: Colors.grey[300]),

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
              strokeWidth: context.isTablet ? 3.0 : 2.0,
            ),
          );
        }

        if (state.isError && !state.hasOrders) {
          return _buildErrorState(state);
        }

        if (!state.hasOrders) {
          // عرض رسالة مختلفة إذا كان هناك طلبات ولكن الفلتر لم يُظهر أي منها
          if (state.isFiltered && state.orders.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.filter_list_off,
                    size: 60.r,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'لا توجد طلبات تطابق الفلتر المحدد',
                    style: TextStyle(color: AppColors.text, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  TextButton.icon(
                    onPressed: () {
                      context.read<OrdersCubit>().clearFilter();
                    },
                    icon: Icon(Icons.filter_list_off, size: 18.r),
                    label: Text(
                      'إزالة الفلتر',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }
          return _buildEmptyState();
        }

        return RefreshIndicator(
          key: _refreshIndicatorKey,
          color: AppColors.primary,
          backgroundColor: Colors.white,
          onRefresh: () async {
            if (mounted) {
              await context.read<OrdersCubit>().loadOrders();
            }
          },
          child: ListView.builder(
            key: const PageStorageKey('orders_list'),
            padding: EdgeInsets.all(context.isTablet ? 20.r : 16.r),
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: state.filteredOrders.length,
            itemBuilder: (context, index) {
              final order = state.filteredOrders[index];
              return OrderItemCard(
                order: order,
                onTap: () {},
                isResponsive: true,
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
              onPressed: () {
                // تحقق إذا كانت الرسالة تحتوي على كلمة توكن أو token
                if (state.errorMessage?.toLowerCase().contains('توكن') ==
                        true ||
                    state.errorMessage?.toLowerCase().contains('token') ==
                        true) {
                  // إذا كان خطأ متعلق بالتوكن، انتقل إلى صفحة تسجيل الدخول
                  context.pushNamedAndRemoveUntil(
                    Routes.loginView,
                    predicate: (route) => false,
                    arguments: {'fresh_start': true},
                  );
                } else {
                  // وإلا حاول إعادة تحميل البيانات
                  context.read<OrdersCubit>().loadOrders();
                }
              },
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
                foregroundColor: Colors.white, // تغيير لتحسين القراءة
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
      onButtonPressed: () {
        context.pushNamedAndRemoveUntil(
          Routes.hostView,
          predicate: (route) => false,
        );
      },
      iconColor: AppColors.primary,
      iconSize: context.isTablet ? 70.r : 50.r, // حجم متجاوب للأيقونة
      titleSize: context.isTablet ? 24.sp : 20.sp, // حجم خط متجاوب للعنوان
      messageSize: context.isTablet ? 18.sp : 16.sp, // حجم خط متجاوب للرسالة
      buttonWidth: context.isTablet ? 240.w : 200.w, // عرض زر متجاوب
    );
  }

  // دالة لعرض مربع حوار التصفية
  void _showFilterBottomSheet(BuildContext context) {
    final ordersCubit = context.read<OrdersCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.unselectedChip,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomSheetContext) {
        // نوفر نفس الـ cubit داخل الـ BottomSheet
        return BlocProvider.value(
          value: ordersCubit,
          child: BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تصفية الطلبات',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // خيارات التصفية
                    _buildFilterOption(
                      context,
                      title: 'جميع الطلبات',
                      isSelected: state.filterStatus == null,
                      onTap: () {
                        context.read<OrdersCubit>().clearFilter();
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    _buildFilterOption(
                      context,
                      title: 'قيد المعالجة',
                      isSelected: state.filterStatus == OrderStatus.processing,
                      onTap: () {
                        context.read<OrdersCubit>().setFilter(
                          OrderStatus.processing,
                        );
                        Navigator.pop(context);
                      },
                    ),

                    _buildFilterOption(
                      context,
                      title: 'تم الشحن',
                      isSelected: state.filterStatus == OrderStatus.shipped,
                      onTap: () {
                        context.read<OrdersCubit>().setFilter(
                          OrderStatus.shipped,
                        );
                        Navigator.pop(context);
                      },
                    ),

                    _buildFilterOption(
                      context,
                      title: 'تم التسليم',
                      isSelected: state.filterStatus == OrderStatus.delivered,
                      onTap: () {
                        context.read<OrdersCubit>().setFilter(
                          OrderStatus.delivered,
                        );
                        Navigator.pop(context);
                      },
                    ),

                    _buildFilterOption(
                      context,
                      title: 'ملغي',
                      isSelected: state.filterStatus == OrderStatus.cancelled,
                      onTap: () {
                        context.read<OrdersCubit>().setFilter(
                          OrderStatus.cancelled,
                        );
                        Navigator.pop(context);
                      },
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
    BuildContext context, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[700]!,
            width: 1.r,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.text,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 20.r),
          ],
        ),
      ),
    );
  }
}