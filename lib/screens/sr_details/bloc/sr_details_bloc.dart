import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/project.dart';
import 'package:insurance_map/repo/social_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'sr_details_event.dart';
part 'sr_details_state.dart';

class SrDetailsBloc extends Bloc<SrDetailsEvent, SrDetailsState> {
  final SocialRepository _repository;

  SrDetailsBloc(this._repository) : super(SrDetailsInitial()) {
    on<SrDetailsGetProjects>((event, emit) async {
      emit(SrDetailsLoading());
      DataState<List<Project>> result = await _repository.getProjects(event.id);
      emit(result is DataError ? SrDetailsError(result.errorMessage??"") : SrDetailsShowProjects(result.data??[]));
    });
  }
}
