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
    return UserOrderEntity(
      id:
          response.orderId?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: response.bookTitle ?? 'طلب جديد',
      description: 'طلب من التطبيق - ${response.bookType ?? ''}',
      orderDate: DateTime.now(),
      status: OrderStatus.processing, // بدء الطلب كـ "قيد المعالجة"
      price: response.amount ?? 0.0,
      imageUrl: null, // يمكن إضافة صورة الكتاب إذا كانت متوفرة
    );
  }

  void resetState() {
    emit(CreatePurchaseInitial());
  }
}
