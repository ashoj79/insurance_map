part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesError extends CategoriesState {
  final String message;
  CategoriesError(this.message);
}

class CategoriesShow extends CategoriesState {
  final List<Category> categories;
  final String currentCategoryId;
  CategoriesShow({required this.categories, required this.currentCategoryId});
}