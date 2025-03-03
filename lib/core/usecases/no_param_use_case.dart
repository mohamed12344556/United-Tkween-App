import 'package:dartz/dartz.dart';

abstract class NoParamUseCase<ErrorType, Type> {
  Future<Either<ErrorType, Type>> call();
}
