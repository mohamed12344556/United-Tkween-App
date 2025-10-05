import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:united_formation_app/features/home/domain/home_repo.dart';
import '../../data/book_model.dart';
import '../../data/categories_model.dart';
import '../../../../core/core.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeRepo homeRepo;

  // قائمة تخزين جميع الكتب للاستخدام في الفلترة
  List<BookModel> allBooks = [];
  // قائمة الكتب المعروضة (قد تكون مفلترة)
  List<BookModel> books = [];
  List<CategoryModel> booksCategories = [];

  HomeCubit({required this.homeRepo}) : super(HomeInitial());

  // void getHomeBooks() async {
  //   emit(HomeBooksLoadingState());

  //   try {
  //     final response = await homeRepo.getHomeBooks();
  //     response.fold(
  //       (failure) {
  //         log("فشل تحميل الكتب: ${failure.errorMessage}");
  //         emit(HomeBooksFailureState(failure.toString()));
  //         // تحميل الفئات حتى في حال فشل تحميل الكتب
  //         getBooksCategories();
  //       },
  //       (booksList) {
  //         // تخزين جميع الكتب للفلترة لاحقًا
  //         allBooks = booksList;
  //         books = booksList;

  //         // سجل معلومات التصحيح
  //         for (var book in books) {
  //           log('Book: ${book.title}, Category EN: ${book.category.nameEn}');
  //         }

  //         emit(HomeBooksSuccessState(books: books));

  //         // تحميل الفئات بعد نجاح تحميل الكتب
  //         getBooksCategories();
  //       }
  //     );
  //   } catch (e) {
  //     log("استثناء غير متوقع في تحميل الكتب: $e");
  //     emit(HomeBooksFailureState(e.toString()));
  //     // محاولة تحميل الفئات حتى في حال حدوث استثناء
  //     getBooksCategories();
  //   }
  // }

  // void getBooksCategories() async {
  //   emit(HomeCategoriesLoadingState());

  //   try {
  //     final response = await homeRepo.getBooksCategories();
  //     response.fold(
  //       (failure) {
  //         log("فشل تحميل الفئات: ${failure.errorMessage}");
  //         emit(HomeCategoriesFailureState(failure.toString()));
  //       },
  //       (categoriesList) {
  //         booksCategories = categoriesList;
  //         emit(HomeCategoriesSuccessState(categories: booksCategories));
  //       }
  //     );
  //   } catch (e) {
  //     log("استثناء غير متوقع في تحميل الفئات: $e");
  //     emit(HomeCategoriesFailureState(e.toString()));
  //   }
  // }

  void getHomeBooks() async {
    emit(HomeBooksLoadingState());

    try {
      final response = await homeRepo.getHomeBooks();
      response.fold(
        (failure) {
          log("فشل تحميل الكتب: ${failure.errorMessage}");

          // التحقق من رسالة الخطأ إذا كانت متعلقة بالتوكن
          if (_isTokenError(failure.errorMessage)) {
            _handleInvalidToken();
            return;
          }

          emit(HomeBooksFailureState(failure.toString()));
          // تحميل الفئات حتى في حال فشل تحميل الكتب
          getBooksCategories();
        },
        (booksList) {
          // تخزين جميع الكتب للفلترة لاحقًا
          allBooks = booksList;
          books = booksList;

          // سجل معلومات التصحيح
          for (var book in books) {
            log('Book: ${book.title}, Category EN: ${book.category.nameEn}');
          }

          emit(HomeBooksSuccessState(books: books));

          // تحميل الفئات بعد نجاح تحميل الكتب
          getBooksCategories();
        },
      );
    } catch (e) {
      log("استثناء غير متوقع في تحميل الكتب: $e");

      // التحقق من الاستثناء إذا كان متعلقًا بالتوكن
      if (_isTokenException(e)) {
        _handleInvalidToken();
        return;
      }

      emit(HomeBooksFailureState(e.toString()));
      // محاولة تحميل الفئات حتى في حال حدوث استثناء
      getBooksCategories();
    }
  }

  Future<BookModel?> getBookDetails(String bookId) async {
    if (isClosed) return null;

    // First, check if we already have this book in cache
    if (allBooks.isNotEmpty) {
      try {
        final book = allBooks.firstWhere((book) => book.id == bookId);
        log('✅ Book found in cache: ${book.title}');
        return book; // Return the book immediately
      } catch (e) {
        log('Book not found in cache, will fetch from API...');
      }
    }

    // Fetch from API if not in cache
    try {
      final response = await homeRepo.getHomeBooks();

      if (isClosed) return null;

      return response.fold(
        (failure) {
          log("فشل تحميل الكتب: ${failure.errorMessage}");

          if (_isTokenError(failure.errorMessage)) {
            _handleInvalidToken();
          }

          return null;
        },
        (booksList) {
          allBooks = booksList;
          books = booksList;

          try {
            final book = booksList.firstWhere((book) => book.id == bookId);

            log(
              'تفاصيل الكتاب المطلوب: ${book.title}, الفئة: ${book.category.nameEn}',
            );
            return book; // Return the found book
          } catch (e) {
            log("الكتاب المطلوب غير موجود في القائمة");
            return null; // Return null if book not found
          }
        },
      );
    } catch (e) {
      log("استثناء غير متوقع في تحميل تفاصيل الكتاب: $e");

      if (_isTokenException(e)) {
        _handleInvalidToken();
      }

      return null; // Return null on exception
    }
  }

  void getBooksCategories() async {
    emit(HomeCategoriesLoadingState());

    try {
      final response = await homeRepo.getBooksCategories();
      response.fold(
        (failure) {
          log("فشل تحميل الفئات: ${failure.errorMessage}");

          // التحقق من رسالة الخطأ إذا كانت متعلقة بالتوكن
          if (_isTokenError(failure.errorMessage)) {
            _handleInvalidToken();
            return;
          }

          emit(HomeCategoriesFailureState(failure.toString()));
        },
        (categoriesList) {
          booksCategories = categoriesList;
          emit(HomeCategoriesSuccessState(categories: booksCategories));
        },
      );
    } catch (e) {
      log("استثناء غير متوقع في تحميل الفئات: $e");

      // التحقق من الاستثناء إذا كان متعلقًا بالتوكن
      if (_isTokenException(e)) {
        _handleInvalidToken();
        return;
      }

      emit(HomeCategoriesFailureState(e.toString()));
    }
  }

  // دالة للتحقق من خطأ التوكن
  bool _isTokenError(String errorMessage) {
    errorMessage = errorMessage.toLowerCase();
    return errorMessage.contains("invalid token") ||
        errorMessage.contains("unauthorized") ||
        errorMessage.contains("401") ||
        errorMessage.contains("authentication");
  }

  // دالة للتحقق من استثناء التوكن
  bool _isTokenException(dynamic exception) {
    String exceptionStr = exception.toString().toLowerCase();
    return exceptionStr.contains("invalid token") ||
        exceptionStr.contains("unauthorized") ||
        exceptionStr.contains("401") ||
        exceptionStr.contains("authentication");
  }

  // دالة للتعامل مع التوكن غير الصالح
  void _handleInvalidToken() {
    // مسح التوكن أولاً
    TokenManager.clearTokens();

    // التوجيه إلى صفحة تسجيل الدخول
    NavigationService.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      Routes.loginView,
      (route) => false,
      arguments: {'fresh_start': true},
    );
  }

  void filterBooksByCategoryEn(String categoryNameEn) {
    emit(HomeBooksLoadingState());

    log('=== بدء التصفية ===');
    log('الفئة المراد التصفية بها: "$categoryNameEn"');

    if (categoryNameEn == 'All') {
      log('عرض جميع الكتب');
      books = allBooks;
      emit(HomeBooksSuccessState(books: books));
    } else {
      List<BookModel> filteredBooks =
          allBooks.where((book) {
            log('فحص الكتاب: ${book.title}');
            log('فئة الكتاب: "${book.category.nameEn}"');
            return book.category.nameEn.trim().toLowerCase() ==
                categoryNameEn.trim().toLowerCase();
          }).toList();

      log('عدد الكتب بعد التصفية: ${filteredBooks.length}');
      for (var b in filteredBooks) {
        log('كتاب مصفى: ${b.title}');
      }

      books = filteredBooks;
      emit(HomeBooksSuccessState(books: filteredBooks));
    }

    log('=== انتهاء التصفية ===');
  }
}
