part of 'add_product_admin_cubit.dart';

abstract class AddProductAdminState extends Equatable {
  const AddProductAdminState();

  @override
  List<Object> get props => [];
}

class AddProductInitial extends AddProductAdminState {}

class AddProductLoading extends AddProductAdminState {}

class AddProductSuccess extends AddProductAdminState {}

class AddProductError extends AddProductAdminState {
  final String message;

  const AddProductError({required this.message});

  @override
  List<Object> get props => [message];
}
