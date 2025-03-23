import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_order_entity.dart';
import '../../../domain/usecases/get_user_orders_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetUserOrdersUseCase _getUserOrdersUseCase;

  Timer? _refreshTimer;

  OrdersCubit({required GetUserOrdersUseCase getUserOrdersUseCase})
    : _getUserOrdersUseCase = getUserOrdersUseCase,
      super(const OrdersState());

  // في OrdersCubit.dart
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
  void setFilter(OrderStatus? filterStatus) {
    final filteredOrders = _applyFilter(state.orders, filterStatus);
    emit(
      state.copyWith(
        filterStatus: filterStatus,
        filteredOrders: filteredOrders,
      ),
    );
  }

  // دالة لإزالة الفلتر
  void clearFilter() {
    emit(state.copyWith(filterStatus: null, filteredOrders: state.orders));
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
