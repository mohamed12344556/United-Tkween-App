import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:united_formation_app/core/core.dart';

import '../../../data/models/product_model.dart';
import '../../../domain/repos/admin_repository.dart';

part 'edit_product_admin_state.dart';

class EditProductAdminCubit extends Cubit<EditProductAdminState> {
  final AdminRepository repository;
  ProductModel? _currentProduct;

  EditProductAdminCubit({required this.repository})
    : super(EditProductInitial());

  void setProduct(ProductModel product) {
    _currentProduct = product;
    emit(EditProductLoaded(product));
  }

  Future<void> updateProduct({
    required String name,
    required String category,
    String? type,
    required double price,
    required int quantity,
    String? description,
    String? imageUrl,
  }) async {
    if (_currentProduct == null) {
      emit(const EditProductError(message: 'لم يتم تحميل المنتج بشكل صحيح'));
      return;
    }

    emit(EditProductLoading());

    final updatedProduct = _currentProduct!.copyWith(
      name: name,
      category: category,
      type: type,
      price: price,
      quantity: quantity,
      description: description,
      imageUrl: imageUrl,
    );

    final result = await repository.updateProduct(updatedProduct);
    emit(
      result.fold(
        (failure) => EditProductError(message: _mapFailureToMessage(failure)),
        (_) => EditProductSuccess(),
      ),
    );
  }

  Future<void> deleteProduct() async {
    if (_currentProduct == null) {
      emit(const EditProductError(message: 'لم يتم تحميل المنتج بشكل صحيح'));
      return;
    }

    emit(EditProductLoading());

    final result = await repository.deleteProduct(_currentProduct!.id);
    emit(
      result.fold(
        (failure) => EditProductError(message: _mapFailureToMessage(failure)),
        (_) => EditProductDeleted(),
      ),
    );
  }

  String _mapFailureToMessage(ApiErrorModel failure) {
    return failure.errorMessage?? 'حدث خطأ غير متوقع';
  }
}
