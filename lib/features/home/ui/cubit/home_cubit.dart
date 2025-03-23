import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:united_formation_app/features/home/domain/home_repo.dart';
import '../../data/book_model.dart';
import '../../data/categories_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeRepo homeRepo;

  // قائمة تخزين جميع الكتب للاستخدام في الفلترة
  List<BookModel> allBooks = [];
  // قائمة الكتب المعروضة (قد تكون مفلترة)
  List<BookModel> books = [];
  List<CategoryModel> booksCategories = [];

  HomeCubit({required this.homeRepo}) : super(HomeInitial());

  void getHomeBooks() async {
    emit(HomeBooksLoadingState());
    
    try {
      final response = await homeRepo.getHomeBooks();
      response.fold(
        (failure) {
          log("فشل تحميل الكتب: ${failure.errorMessage}");
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
        }
      );
    } catch (e) {
      log("استثناء غير متوقع في تحميل الكتب: $e");
      emit(HomeBooksFailureState(e.toString()));
      // محاولة تحميل الفئات حتى في حال حدوث استثناء
      getBooksCategories();
    }
  }

  void getBooksCategories() async {
    emit(HomeCategoriesLoadingState());
    
    try {
      final response = await homeRepo.getBooksCategories();
      response.fold(
        (failure) {
          log("فشل تحميل الفئات: ${failure.errorMessage}");
          emit(HomeCategoriesFailureState(failure.toString()));
        }, 
        (categoriesList) {
          booksCategories = categoriesList;
          emit(HomeCategoriesSuccessState(categories: booksCategories));
        }
      );
    } catch (e) {
      log("استثناء غير متوقع في تحميل الفئات: $e");
      emit(HomeCategoriesFailureState(e.toString()));
    }
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
      List<BookModel> filteredBooks = allBooks.where((book) {
        log('فحص الكتاب: ${book.title}');
        log('فئة الكتاب: "${book.category.nameEn}"');
        return book.category.nameEn.trim().toLowerCase() == categoryNameEn.trim().toLowerCase();
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