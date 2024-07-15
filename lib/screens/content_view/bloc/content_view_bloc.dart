import 'package:bloc/bloc.dart';
import 'package:insurance_map/repo/main_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'content_view_event.dart';
part 'content_view_state.dart';

class ContentViewBloc extends Bloc<ContentViewEvent, ContentViewState> {
  final MainRepository _repository;

  ContentViewBloc(this._repository) : super(ContentViewInitial()) {
    on<ContentViewEvent>((event, emit) async {
      emit(ContentViewLoading());
      DataState<String> result = await _repository.getPageContent('about-us');
      emit(ContentViewShow(result.data ?? ''));
    });
  }
}
