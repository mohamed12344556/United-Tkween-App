import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/datasources/hive_models/order_hive_model.dart';
import '../../../domain/entities/user_order_entity.dart';
import '../../../domain/usecases/get_user_orders_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetUserOrdersUseCase _getUserOrdersUseCase;
  final List<UserOrderEntity> _localOrders = [];
 final Box<OrderHiveModel> ordersBox = Hive.box<OrderHiveModel>('orders_box');

  Timer? _refreshTimer;

  OrdersCubit({required GetUserOrdersUseCase getUserOrdersUseCase})
    : _getUserOrdersUseCase = getUserOrdersUseCase,
      super(const OrdersState());

  Future<void> _initHive() async {
    // ordersBox = await Hive.openBox<OrderHiveModel>('orders_box');
    _loadCachedOrders();
  }

  void _loadCachedOrders() {
    final cachedOrders = ordersBox.values.toList();
    if (cachedOrders.isNotEmpty) {
      emit(
        state.copyWith(
          orders: cachedOrders.map((e) => e.toUserOrderEntity()).toList(),
        ),
      );
    }
  }

  Future<void> loadOrders() async {
    if (isClosed) return;

    emit(state.copyWith(status: OrdersStatus.loading));

    final result = await _getUserOrdersUseCase();

    if (isClosed) return;

    result.fold(
      (error) => emit(
        state.copyWith(
          status: OrdersStatus.error,
          errorMessage: error.errorMessage ?? 'خطأ في تحميل المشتريات',
        ),
      ),
      (orders) {
        // تطبيق الفلتر الحالي على الطلبات المستلمة
        final filteredOrders = _applyFilter(orders, state.filterStatus);
        emit(
          state.copyWith(
            status: OrdersStatus.success,
            orders: orders,
            filteredOrders: filteredOrders,
          ),
        );
      },
    );
  }

  // void addLocalOrder(UserOrderEntity order) {
  //   _localOrders.insert(0, order); // إضافة الطلب في بداية القائمة
  //   final allOrders = [..._localOrders];
  //   final filteredOrders = _applyFilter(allOrders, state.filterStatus);
  //   emit(state.copyWith(orders: allOrders, filteredOrders: filteredOrders));
  // }

  void addLocalOrder(UserOrderEntity newOrder) {
    final updatedOrders = [...state.orders, newOrder];
    ordersBox.add(OrderHiveModel.fromUserOrderEntity(newOrder));

    emit(state.copyWith(orders: updatedOrders, filteredOrders: updatedOrders));
  }

  // دالة لتطبيق الفلتر على قائمة الطلبات
  List<UserOrderEntity> _applyFilter(
    List<UserOrderEntity> orders,
    OrderStatus? filterStatus,
  ) {
    if (filterStatus == null) {
      return orders;
    }
    return orders.where((order) => order.status == filterStatus).toList();
  }

  // دالة لتعيين فلتر
  // void setFilter(OrderStatus? filterStatus) {
  //   final filteredOrders = _applyFilter(state.orders, filterStatus);
  //   emit(
  //     state.copyWith(
  //       filterStatus: filterStatus,
  //       filteredOrders: filteredOrders,
  //     ),
  //   );
  // }

  // دالة لإزالة الفلتر
  // void clearFilter() {
  //   emit(state.copyWith(filterStatus: null, filteredOrders: state.orders));
  // }

  void setFilter(OrderStatus status) {
    final filtered =
        state.orders.where((order) => order.status == status).toList();
    emit(
      state.copyWith(
        filteredOrders: filtered,
        filterStatus: status,
      ),
    );
  }

  void clearFilter() {
    emit(
      state.copyWith(
        filteredOrders: state.orders,
        filterStatus: null,
      ),
    );
  }

  void selectOrder(String orderId) {
    final selectedOrder = state.orders.firstWhere(
      (order) => order.id == orderId,
      orElse: () => state.orders.first,
    );

    emit(state.copyWith(selectedOrder: selectedOrder));
  }

  void clearSelectedOrder() {
    emit(state.copyWith(selectedOrder: null));
  }

  void _cancelAllTimers() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  Future<void> close() {
    _cancelAllTimers();
    return super.close();
  }
}
