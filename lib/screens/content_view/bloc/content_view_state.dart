part of 'content_view_bloc.dart';

@immutable
sealed class ContentViewState {}

final class ContentViewInitial extends ContentViewState {}

class ContentViewLoading extends ContentViewState {}

class ContentViewShow extends ContentViewState {
  final String html;
  ContentViewShow(this.html);
}