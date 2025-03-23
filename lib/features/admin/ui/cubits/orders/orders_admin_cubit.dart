import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:united_formation_app/core/core.dart';

import '../../../data/models/order_model.dart';
import '../../../domain/repos/admin_repository.dart';

part 'orders_admin_state.dart';

class OrdersAdminCubit extends Cubit<OrdersAdminState> {
  final AdminRepository repository;

  OrdersAdminCubit({required this.repository}) : super(OrdersInitial());

  Future<void> loadOrders() async {
    emit(OrdersLoading());
    final result = await repository.getOrders();
    emit(
      result.fold(
        (failure) => OrdersError(
          message: _mapFailureToMessage(failure) ?? 'Unknown error',
        ),
        (orders) => OrdersLoaded(orders),
      ),
    );
  }

  Future<void> getOrderDetails(String orderId) async {
    emit(OrdersLoading());
    final result = await repository.getOrderById(orderId);
    emit(
      result.fold(
        (failure) => OrdersError(
          message: _mapFailureToMessage(failure) ?? 'Unknown error',
        ),
        (order) => OrderDetailLoaded(order),
      ),
    );
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    emit(OrdersLoading());
    final result = await repository.updateOrderStatus(orderId, status);
    result.fold(
      (failure) => emit(
        OrdersError(message: _mapFailureToMessage(failure) ?? 'Unknown error'),
      ),
      (_) async {
        // Reload the orders after updating status
        await loadOrders();
      },
    );
  }

  String? _mapFailureToMessage(ApiErrorModel? failure) {
    return failure!.errorMessage;
  }
}
