import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/local/temp_db.dart';
import 'package:insurance_map/repo/main_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'content_view_event.dart';
part 'content_view_state.dart';

class ContentViewBloc extends Bloc<ContentViewEvent, ContentViewState> {
  final MainRepository _repository;

  ContentViewBloc(this._repository) : super(ContentViewInitial()) {
    on<ContentViewGet>((event, emit) async {
      emit(ContentViewShow(TempDB.getPage(event.page)));
    });
  }
}
