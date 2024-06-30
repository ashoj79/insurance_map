part of 'main_bloc.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}

class MainLoading extends MainState {}

class MainError extends MainState {
  final String message;
  MainError(this.message);
}

class MainDataReceived extends MainState {
  final List<SliderModel> sliders;
  final List<Category> categories;
  MainDataReceived({required this.sliders, required this.categories});
}