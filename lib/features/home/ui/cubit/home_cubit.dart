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

    List<BookModel> filteredBooks = books.where((book) {
      return book.category.nameEn == categoryNameEn;
    }).toList();

    emit(HomeBooksSuccessState(books: filteredBooks));
  }


}
