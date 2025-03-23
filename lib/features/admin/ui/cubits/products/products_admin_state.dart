part of 'products_admin_cubit.dart';

abstract class ProductsAdminState extends Equatable {
  const ProductsAdminState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsAdminState {}

class ProductsLoading extends ProductsAdminState {}

class ProductsLoaded extends ProductsAdminState {
  final List<ProductModel> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductDetailLoaded extends ProductsAdminState {
  final ProductModel product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductsError extends ProductsAdminState {
  final String message;

  const ProductsError({required this.message});

  @override
  List<Object> get props => [message];
}