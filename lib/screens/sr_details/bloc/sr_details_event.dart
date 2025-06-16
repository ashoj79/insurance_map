part of 'sr_details_bloc.dart';

@immutable
sealed class SrDetailsEvent {}

class SrDetailsGetProjects extends SrDetailsEvent {
  final String id;
  SrDetailsGetProjects(this.id);
}