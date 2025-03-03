import 'package:dartz/dartz.dart';

abstract class UseCase<ErrorType, Type, Param> {
  Future<Either<ErrorType, Type>> call(Param params);
}
