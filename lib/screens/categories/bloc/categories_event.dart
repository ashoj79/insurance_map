part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {}

class CategoriesFetch extends CategoriesEvent {
  final String parentId;
  CategoriesFetch(this.parentId);
}

class CategoriesBack extends CategoriesEvent {}