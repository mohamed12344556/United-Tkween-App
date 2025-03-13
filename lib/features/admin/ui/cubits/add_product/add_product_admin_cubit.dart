import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:united_formation_app/core/core.dart';
import 'package:united_formation_app/features/admin/domain/repos/admin_repository.dart';

import '../../../data/models/product_model.dart';

part 'add_product_admin_state.dart';

class AddProductAdminCubit extends Cubit<AddProductAdminState> {
  final AdminRepository repository;

  AddProductAdminCubit({required this.repository}) : super(AddProductInitial());

  Future<void> addProduct({
    required String name,
    required String category,
    String? type,
    required double price,
    required int quantity,
    String? description,
    String? imageUrl,
  }) async {
    emit(AddProductLoading());

    final product = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      category: category,
      type: type,
      price: price,
      quantity: quantity,
      description: description,
      imageUrl: imageUrl,
    );

    final result = await repository.addProduct(product);
    emit(
      result.fold(
        (failure) => AddProductError(message: _mapFailureToMessage(failure)),
        (_) => AddProductSuccess(),
      ),
    );
  }

  String _mapFailureToMessage(ApiErrorModel failure) {
    return failure.errorMessage?.message ?? 'حدث خطأ غير متوقع';
  }
}
