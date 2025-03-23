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
