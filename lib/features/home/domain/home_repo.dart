import 'package:dartz/dartz.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';
import '../../../core/api/dio_services_failures.dart';
import '../data/categories_model.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<BookModel>>> getHomeBooks();
  Future<Either<Failure, List<CategoryModel>>> getBooksCategories();
  Future<Either<Failure, BookModel>> getBookById(String bookId);
}
