import 'package:equatable/equatable.dart';
import 'package:united_formation_app/features/cart/data/repos/create_purchase_service.dart';
import 'package:united_formation_app/features/settings/domain/entities/user_order_entity.dart';

// States
abstract class CreatePurchaseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreatePurchaseInitial extends CreatePurchaseState {}

class CreatePurchaseLoading extends CreatePurchaseState {}

class CreatePurchaseSuccess extends CreatePurchaseState {
  final CreatePurchaseResponse response;
  final UserOrderEntity? orderEntity;

  CreatePurchaseSuccess({required this.response, this.orderEntity});

  @override
  List<Object?> get props => [response, orderEntity];
}

class CreatePurchaseError extends CreatePurchaseState {
  final String errorMessage;

  CreatePurchaseError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
