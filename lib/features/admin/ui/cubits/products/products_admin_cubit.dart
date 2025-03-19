import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/api_error_model.dart';
import '../../../data/models/product_model.dart';
import '../../../domain/repos/admin_repository.dart';

part 'products_admin_state.dart';

class ProductsAdminCubit extends Cubit<ProductsAdminState> {
  final AdminRepository repository;

  ProductsAdminCubit({required this.repository}) : super(ProductsInitial());

  Future<void> loadProducts() async {
    emit(ProductsLoading());
    final result = await repository.getProducts();
    emit(
      result.fold(
        (failure) => ProductsError(message: _mapFailureToMessage(failure)),
        (products) => ProductsLoaded(products),
      ),
    );
  }

  Future<void> getProductDetails(String productId) async {
    emit(ProductsLoading());
    final result = await repository.getProductById(productId);
    emit(
      result.fold(
        (failure) => ProductsError(message: _mapFailureToMessage(failure)),
        (product) => ProductDetailLoaded(product),
      ),
    );
  }

  Future<void> addProduct(ProductModel product) async {
    emit(ProductsLoading());
    final result = await repository.addProduct(product);
    result.fold(
      (failure) => emit(ProductsError(message: _mapFailureToMessage(failure))),
      (_) async {
        // Reload the products after adding
        await loadProducts();
      },
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    emit(ProductsLoading());
    final result = await repository.updateProduct(product);
    result.fold(
      (failure) => emit(ProductsError(message: _mapFailureToMessage(failure))),
      (_) async {
        // Reload the products after updating
        await loadProducts();
      },
    );
  }

  Future<void> deleteProduct(String productId) async {
    emit(ProductsLoading());
    final result = await repository.deleteProduct(productId);
    result.fold(
      (failure) => emit(ProductsError(message: _mapFailureToMessage(failure))),
      (_) async {
        // Reload the products after deleting
        await loadProducts();
      },
    );
  }

  String _mapFailureToMessage(ApiErrorModel failure) {
    return failure.errorMessage?? 'حدث خطأ غير متوقع';
  }
}
