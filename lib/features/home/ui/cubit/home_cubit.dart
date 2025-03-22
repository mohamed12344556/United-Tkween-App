import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:united_formation_app/features/home/domain/home_repo.dart';
import '../../data/book_model.dart';
import '../../data/categories_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeRepo homeRepo;

  HomeCubit({required this.homeRepo}) : super(HomeInitial());

  List<BookModel> books = [];
  List<CategoryModel> booksCategories = [];

  void getHomeBooks() async {
    emit(HomeBooksLoadingState());
    final response = await homeRepo.getHomeBooks();
    response.fold((l) => emit(HomeBooksFailureState(l.toString())), (r) {
      books = r;
      // Debug prints
      for (var book in books) {
        print('Book: ${book.title}, Category EN: ${book.category.nameEn}');
      }
      emit(HomeBooksSuccessState(books: r));
    });
  }

  void getBooksCategories() async {
    emit(HomeCategoriesLoadingState());
    final response = await homeRepo.getBooksCategories();
    response.fold((l) => emit(HomeCategoriesFailureState(l.toString())), (r) {
      booksCategories = r;
      emit(HomeCategoriesSuccessState(categories: booksCategories));
    });
  }

  void filterBooksByCategoryEn(String categoryNameEn) {
    emit(HomeBooksLoadingState());

    print('=== FILTER START ===');
    print('Category to filter by: "$categoryNameEn"');

    if (categoryNameEn == 'All') {
      print('Showing ALL books');
      emit(HomeBooksSuccessState(books: books));
    } else {
      List<BookModel> filteredBooks = books.where((book) {
        print('Checking book: ${book.title}');
        print('Book category: "${book.category.nameEn}"');
        return book.category.nameEn.trim().toLowerCase() == categoryNameEn.trim().toLowerCase();
      }).toList();

      print('Filtered books count: ${filteredBooks.length}');
      for (var b in filteredBooks) {
        print('Filtered book: ${b.title}');
      }

      emit(HomeBooksSuccessState(books: filteredBooks));
    }

    print('=== FILTER END ===');
  }




}
