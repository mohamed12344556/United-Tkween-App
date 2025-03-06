import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_order_entity.dart';

enum OrdersStatus { initial, loading, success, error }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<UserOrderEntity> orders;
  final UserOrderEntity? selectedOrder;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.selectedOrder,
    this.errorMessage,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<UserOrderEntity>? orders,
    UserOrderEntity? selectedOrder,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, selectedOrder, errorMessage];

  // Helper states
  bool get isInitial => status == OrdersStatus.initial;
  bool get isLoading => status == OrdersStatus.loading;
  bool get isSuccess => status == OrdersStatus.success;
  bool get isError => status == OrdersStatus.error;
  bool get hasOrders => orders.isNotEmpty;
}