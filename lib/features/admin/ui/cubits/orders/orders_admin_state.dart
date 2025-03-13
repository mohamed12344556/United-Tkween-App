part of 'orders_admin_cubit.dart';

abstract class OrdersAdminState extends Equatable {
  const OrdersAdminState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersAdminState {}

class OrdersLoading extends OrdersAdminState {}

class OrdersLoaded extends OrdersAdminState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class OrderDetailLoaded extends OrdersAdminState {
  final OrderModel order;

  const OrderDetailLoaded(this.order);

  @override
  List<Object> get props => [order];
}

class OrdersError extends OrdersAdminState {
  final String message;

  const OrdersError({required this.message});

  @override
  List<Object> get props => [message];
}
