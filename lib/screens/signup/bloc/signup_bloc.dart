import 'package:bloc/bloc.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _repository;
  String type = '';

  SignupBloc(this._repository) : super(SignupInitial()) {
    on<SignupSendOtp>((event, emit) async {
      String phone = '0${event.phone}';
      if (int.tryParse(phone) == null || phone.length != 11) {
        emit(SignupError('شماره وارد شده غلط است'));
        return;
      }

      emit(SignupLoading());

      DataState<String> result = await _repository.sendOtp(phone);
      if (result is DataSucces) type = result.data!;

      emit(result is DataSucces ? SignupGetOtp() : SignupError(result.errorMessage!));
    });

    on<SignupValidateOtp>((event, emit) async {
      String phone = '0${event.phone}', otp = event.otp;
      if (int.tryParse(otp) == null || otp.length != 6) {
        emit(SignupError('کد وارد شده غلط است'));
        return;
      }

      emit(SignupLoading());

      DataState<void> result = await _repository.validateOtp(phone, otp, type);
      if (result is DataError) {
        emit(SignupError(result.errorMessage!));
        return;
      }

      emit(type == 'register' ? SignupDoSignup() : SignupDoLogin());
    });
  }
}
