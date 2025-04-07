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
  late Box<OrderHiveModel> ordersBox;

  Timer? _refreshTimer;

  OrdersCubit({required GetUserOrdersUseCase getUserOrdersUseCase})
    : _getUserOrdersUseCase = getUserOrdersUseCase,
      super(const OrdersState()) {
    // تهيئة Hive مباشرة
    initialize();
  }

  // Add this method to the OrdersCubit class
  Future<void> initialize() async {
    if (isClosed) return;

    emit(state.copyWith(status: OrdersStatus.loading));

    try {
      if (!Hive.isBoxOpen('orders_box')) {
        ordersBox = await Hive.openBox<OrderHiveModel>('orders_box');
      } else {
        ordersBox = Hive.box<OrderHiveModel>('orders_box');
      }

      // تحميل البيانات المحفوظة دائمًا
      final cachedOrders = ordersBox.values.toList();
      if (cachedOrders.isNotEmpty) {
        emit(
          state.copyWith(
            orders: cachedOrders.map((e) => e.toUserOrderEntity()).toList(),
            filteredOrders:
                cachedOrders.map((e) => e.toUserOrderEntity()).toList(),
            status: OrdersStatus.success,
          ),
        );
      }

      // تحميل البيانات من الخادم (اختياري)
      // await loadOrders();
    } catch (e) {
      emit(
        state.copyWith(
          status: OrdersStatus.error,
          errorMessage: 'فشل في تحميل البيانات: $e',
        ),
      );
    }
  }

  Future<void> _initHive() async {
    try {
      // افتح الصندوق إذا لم يكن مفتوحًا بالفعل
      if (!Hive.isBoxOpen('orders_box')) {
        ordersBox = await Hive.openBox<OrderHiveModel>('orders_box');
      } else {
        ordersBox = Hive.box<OrderHiveModel>('orders_box');
      }

      print(
        "Hive box opened successfully. Contains ${ordersBox.length} orders.",
      );
      loadCachedOrders();
    } catch (e) {
      print("Error initializing Hive: $e");
      emit(
        state.copyWith(
          status: OrdersStatus.error,
          errorMessage: 'فشل في تهيئة التخزين المحلي: $e',
        ),
      );
    }
  }

  Future<void> loadCachedOrders() async {
    if (isClosed) return;

    emit(state.copyWith(status: OrdersStatus.loading));
    final cachedOrders = await ordersBox.values.toList();
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

  Future<void> addLocalOrder(UserOrderEntity newOrder) async {
    if (!Hive.isBoxOpen('orders_box')) {
      await _initHive(); // تأكد من فتح الصندوق أولًا
    }

    final hiveModel = OrderHiveModel.fromUserOrderEntity(newOrder);
    await ordersBox.add(hiveModel); // استخدم await لحفظ البيانات بشكل دائم

    emit(
      state.copyWith(
        orders: [...state.orders, newOrder],
        filteredOrders: [...state.filteredOrders, newOrder],
      ),
    );
  }

  List<UserOrderEntity> _applyFilter(
    List<UserOrderEntity> orders,
    OrderStatus? filterStatus,
  ) {
    if (filterStatus == null) {
      return orders;
    }
    return orders.where((order) => order.status == filterStatus).toList();
  }

  void setFilter(OrderStatus status) {
    final filtered =
        state.orders.where((order) => order.status == status).toList();
    emit(state.copyWith(filteredOrders: filtered, filterStatus: status));
  }

  void clearFilter() {
    emit(state.copyWith(filteredOrders: state.orders, filterStatus: null));
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
