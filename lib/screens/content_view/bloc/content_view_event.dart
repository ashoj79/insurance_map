part of 'content_view_bloc.dart';

@immutable
sealed class ContentViewEvent {}

class ContentViewGet extends ContentViewEvent {
  final String page;
  ContentViewGet(this.page);
}