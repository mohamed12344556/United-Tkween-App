import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:united_formation_app/features/cart/data/repos/create_purchase_service.dart';
import 'package:united_formation_app/features/settings/domain/entities/user_order_entity.dart';

import '../../../settings/ui/cubits/orders/orders_cubit.dart';
import 'purchase_state.dart';

class CreatePurchaseCubit extends Cubit<CreatePurchaseState> {
  final CreatePurchaseService _createPurchaseService;
  final OrdersCubit? _ordersCubit;

  CreatePurchaseCubit({
    required CreatePurchaseService createPurchaseService,
    OrdersCubit? ordersCubit,
  }) : _createPurchaseService = createPurchaseService,
       _ordersCubit = ordersCubit,
       super(CreatePurchaseInitial());

  Future<void> createSingleBookPurchase({
    required String bookId,
    required String fullName,
    required String email,
    required String phone,
    required String address,
    String paymentMethod = 'credit_card',
  }) async {
    emit(CreatePurchaseLoading());

    try {
      final response = await _createPurchaseService.createPurchase(
        bookId: bookId,
        fullName: fullName,
        email: email,
        phone: phone,
        address: address,
        paymentMethod: paymentMethod,
      );

      if (response.success) {
        // Create order entity and add to local orders
        final orderEntity = _createOrderEntityFromResponse(response);
        await _ordersCubit?.addLocalOrder(orderEntity);

        emit(
          CreatePurchaseSuccess(response: response, orderEntity: orderEntity),
        );
      } else {
        emit(CreatePurchaseError(errorMessage: response.message));
      }
    } catch (e) {
      emit(
        CreatePurchaseError(
          errorMessage: 'خطأ في إنشاء الطلب: ${e.toString()}',
        ),
      );
    }
  }

  // Future<void> createMultipleBooksPurchase({
  //   required List<String> bookIds,
  //   required List<int> quantities,
  //   required String fullName,
  //   required String email,
  //   required String phone,
  //   required String address,
  //   String paymentMethod = 'credit_card',
  // }) async {
  //   emit(CreatePurchaseLoading());

  //   try {
  //     final response = await _createPurchaseService.createMultipleBooksPurchase(
  //       bookIds: bookIds,
  //       quantities: quantities,
  //       fullName: fullName,
  //       email: email,
  //       phone: phone,
  //       address: address,
  //       paymentMethod: paymentMethod,
  //     );

  //     if (response.success) {
  //       final orderEntity = _createOrderEntityFromResponse(response);
  //       await _ordersCubit?.addLocalOrder(orderEntity);

  //       emit(
  //         CreatePurchaseSuccess(response: response, orderEntity: orderEntity),
  //       );
  //     } else {
  //       emit(CreatePurchaseError(errorMessage: response.message));
  //     }
  //   } catch (e) {
  //     emit(
  //       CreatePurchaseError(
  //         errorMessage: 'خطأ في إنشاء الطلب: ${e.toString()}',
  //       ),
  //     );
  //   }
  // }

  UserOrderEntity _createOrderEntityFromResponse(
    CreatePurchaseResponse response,
  ) {
    // Build price summary from response
    OrderPriceSummary? priceSummary;
    if (response.priceDetails != null) {
      priceSummary = OrderPriceSummary(
        subtotal: response.priceDetails!.subtotal,
        taxAmount: response.priceDetails!.taxAmount,
        shippingCost: response.priceDetails!.shippingCost,
        total: response.priceDetails!.total,
      );
    }

    // Build customer from response
    OrderCustomer? customer;
    if (response.customerDetails != null) {
      customer = OrderCustomer(
        name: response.customerDetails!.name,
        email: response.customerDetails!.email,
        phone: response.customerDetails!.phone,
        address: response.customerDetails!.address ?? '',
      );
    }

    // Build payment from response
    OrderPayment? payment;
    if (response.paymentMethod != null) {
      payment = OrderPayment(method: response.paymentMethod!);
    }

    // Build shipping from response
    OrderShipping? shipping;
    if (response.appliedShipping != null) {
      shipping = OrderShipping(
        methodName: response.appliedShipping!.name,
        cost: response.appliedShipping!.cost,
      );
    }

    // Build book item
    final books = <OrderBookItem>[];
    if (response.bookTitle != null) {
      books.add(OrderBookItem(
        bookId: response.orderId?.toString() ?? '',
        title: response.bookTitle!,
        unitPrice: response.priceDetails?.subtotal ?? 0,
        quantity: 1,
        total: response.priceDetails?.subtotal ?? 0,
      ));
    }

    return UserOrderEntity(
      id:
          response.orderId?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      chargeId: response.chargeId,
      title: response.bookTitle ?? 'طلب جديد',
      description: 'طلب من التطبيق - ${response.bookType ?? ''}',
      orderDate: DateTime.now(),
      status: OrderStatus.processing,
      price: response.amount ?? 0.0,
      books: books,
      customer: customer,
      payment: payment,
      priceSummary: priceSummary,
      shipping: shipping,
      shippingAddress: response.customerDetails?.address,
    );
  }

  void resetState() {
    emit(CreatePurchaseInitial());
  }
}
