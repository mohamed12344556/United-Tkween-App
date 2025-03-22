import 'package:dartz/dartz.dart';
import 'package:united_formation_app/core/api/dio_services.dart';
import 'package:united_formation_app/core/api/dio_services_failures.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';

import '../data/categories_model.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final DioService dioService;

  HomeRepoImpl({required this.dioService});

  @override
  Future<Either<Failure, List<BookModel>>> getHomeBooks() async {
    try {
      final response = await dioService.getRequest(ApiConstants.homeBooks);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Parse the JSON to our model
        final booksResponse = BooksResponse.fromJson(data);

        // Convert to List<BookModel> if it's not already in that form
        final List<BookModel> books = booksResponse.books;

        return Right(books);
      } else {
        return Left(ServerFailure('Unexpected error: ${response.statusMessage}'));
      }

    } catch (e) {
      return Left(ServerFailure('Exception: ${e.toString()}'));
    }
  }


  @override
  Future<Either<Failure, List<CategoryModel>>> getBooksCategories() async {
    try {
      final response = await dioService.getRequest(ApiConstants.booksCategories);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final categoriesResponse = CategoriesResponse.fromJson(data);

        final List<CategoryModel> categories = categoriesResponse.categories;

        return Right(categories);
      } else {
        return Left(ServerFailure('Unexpected error: ${response.statusMessage}'));
      }

    } catch (e) {
      return Left(ServerFailure('Exception: ${e.toString()}'));
    }
  }


}