part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

///Home Books States
final class HomeBooksLoadingState extends HomeState {}

final class HomeBooksSuccessState extends HomeState {
  final List<BookModel> books;

  HomeBooksSuccessState({required this.books});
}

final class HomeBooksFailureState extends HomeState {
  final String errorMessage;

  HomeBooksFailureState(this.errorMessage);
}

///Books Categories States
final class HomeCategoriesLoadingState extends HomeState {}

final class HomeCategoriesSuccessState extends HomeState {
  final List<CategoryModel> categories;

  HomeCategoriesSuccessState({required this.categories});
}

final class HomeCategoriesFailureState extends HomeState {
  final String errorMessage;

  HomeCategoriesFailureState(this.errorMessage);
}

// Loading State
class BookDetailsLoadingState extends HomeState {}

// Success State
class BookDetailsSuccessState extends HomeState {
  final BookModel book;

  BookDetailsSuccessState({required this.book});
}

// Failure State
class BookDetailsFailureState extends HomeState {
  final String errorMessage;

  BookDetailsFailureState(this.errorMessage);
}

// Add these to your home_state.dart file
class BookDetailLoadingState extends HomeState {}

class BookDetailSuccessState extends HomeState {
  final BookModel book;

  BookDetailSuccessState(this.book);
}

class BookDetailFailureState extends HomeState {
  final String errorMessage;

  BookDetailFailureState(this.errorMessage);
}
