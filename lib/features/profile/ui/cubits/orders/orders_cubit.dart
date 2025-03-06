import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_user_orders_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetUserOrdersUseCase _getUserOrdersUseCase;

  OrdersCubit({
    required GetUserOrdersUseCase getUserOrdersUseCase,
  })  : _getUserOrdersUseCase = getUserOrdersUseCase,
        super(const OrdersState());

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading));

    final result = await _getUserOrdersUseCase();

    result.fold(
      (error) => emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: error.errorMessage?.message ?? 'خطأ في تحميل المشتريات',
      )),
      (orders) => emit(state.copyWith(
        status: OrdersStatus.success,
        orders: orders,
      )),
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
}