import 'package:bloc/bloc.dart';
import 'package:insurance_map/repo/main_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final MainRepository _repository;

  TicketBloc(this._repository) : super(TicketInitial()) {
    on<TicketSend>((event, emit) async {
      if (event.title.isEmpty) {
        emit(TicketError('لطفا عنوان تیکت را وارد کنید'));
        return;
      }

      if (event.message.isEmpty) {
        emit(TicketError('لطفا متن پیام تیکت را وارد کنید'));
        return;
      }

      emit(TicketLoading());
      DataState<void> result = await _repository.sendTicket(event.title, event.message, event.priority);
      emit(result is DataSucces ? TicketSuccess() : TicketError(result.errorMessage!));
    });
  }
}
