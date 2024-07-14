part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

class MainGetData extends MainEvent {}

class MainGoToBankCards extends MainEvent {}