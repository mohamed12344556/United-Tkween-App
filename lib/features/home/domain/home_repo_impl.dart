import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart'; // قم بإضافة هذا الاستيراد للوصول إلى DioException
import 'package:united_formation_app/core/api/dio_services.dart'; // أخفِ ApiConstants من هذا الاستيراد
import 'package:united_formation_app/core/api/dio_services_failures.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';

import '../../../core/core.dart' hide ApiConstants;
import '../data/categories_model.dart';
import 'home_repo.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:united_formation_app/core/api/dio_services.dart';
import 'package:united_formation_app/core/api/dio_services_failures.dart';
import 'package:united_formation_app/features/home/data/book_model.dart';

import '../../../core/core.dart' hide ApiConstants;
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
        final booksResponse = BooksResponse.fromJson(data);
        final List<BookModel> books = booksResponse.books;
        return Right(books);
      } else {
        return Left(
          ServerFailure('Unexpected error: ${response.statusMessage}'),
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.loginView,
          (route) => false,
          arguments: {'fresh_start': true},
        );
      }
      return Left(ServerFailure('Exception: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, BookModel>> getBookById(String bookId) async {
    try {
      final response = await dioService.getRequest(ApiConstants.homeBooks);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final booksResponse = BooksResponse.fromJson(data);
        final List<BookModel> books = booksResponse.books;

        // Filter to find the specific book
        try {
          final book = books.firstWhere((book) => book.id == bookId);
          return Right(book);
        } catch (e) {
          return Left(ServerFailure('الكتاب المطلوب غير موجود'));
        }
      } else {
        return Left(
          ServerFailure('Unexpected error: ${response.statusMessage}'),
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.loginView,
          (route) => false,
          arguments: {'fresh_start': true},
        );
      }
      return Left(ServerFailure('Exception: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getBooksCategories() async {
    try {
      final response = await dioService.getRequest(
        ApiConstants.booksCategories,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final categoriesResponse = CategoriesResponse.fromJson(data);
        final List<CategoryModel> categories = categoriesResponse.categories;
        return Right(categories);
      } else {
        return Left(
          ServerFailure('Unexpected error: ${response.statusMessage}'),
        );
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          Routes.loginView,
          (route) => false,
          arguments: {'fresh_start': true},
        );
      }
      return Left(ServerFailure('Exception: ${e.toString()}'));
    }
  }
}
