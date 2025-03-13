part of 'edit_product_admin_cubit.dart';

abstract class EditProductAdminState extends Equatable {
  const EditProductAdminState();

  @override
  List<Object> get props => [];
}

class EditProductInitial extends EditProductAdminState {}

class EditProductLoading extends EditProductAdminState {}

class EditProductLoaded extends EditProductAdminState {
  final ProductModel product;

  const EditProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class EditProductSuccess extends EditProductAdminState {}

class EditProductDeleted extends EditProductAdminState {}

class EditProductError extends EditProductAdminState {
  final String message;

  const EditProductError({required this.message});

  @override
  List<Object> get props => [message];
}
