part of 'sr_details_bloc.dart';

@immutable
sealed class SrDetailsState {}

final class SrDetailsInitial extends SrDetailsState {}

class SrDetailsLoading extends SrDetailsState {}

class SrDetailsError extends SrDetailsState {
  final String message;
  SrDetailsError(this.message);
}

class SrDetailsShowProjects extends SrDetailsState {
  final List<Project> projects;
  SrDetailsShowProjects(this.projects);
}