import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sr_details_event.dart';
part 'sr_details_state.dart';

class SrDetailsBloc extends Bloc<SrDetailsEvent, SrDetailsState> {
  SrDetailsBloc() : super(SrDetailsInitial()) {
    on<SrDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
