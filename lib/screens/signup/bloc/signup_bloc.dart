import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/local/signup_step_one_data.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _repository;
  String type = '', phone = '', otp = '';

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

      emit(result is DataSucces
          ? SignupGetOtp(event.phone)
          : SignupError(result.errorMessage!));
    });

    on<SignupValidateOtp>((event, emit) async {
      phone = '0${event.phone}';
      otp = event.otp;
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

    on<SignupSubmitStepOne>((event, emit) async {
      if (event.fname.length < 3) {
        emit(SignupError('نام خود را وارد کنید'));
        return;
      }

      if (event.lname.length < 3) {
        emit(SignupError('نام خانوادگی خود را وارد کنید'));
        return;
      }

      if (event.fatherName.length < 3) {
        emit(SignupError('نام پدر خود را وارد کنید'));
        return;
      }

      if (event.nc.length != 10 || int.tryParse(event.nc) == null) {
        emit(SignupError('کد خود را وارد کنید'));
        return;
      }

      if (event.certId.isEmpty || int.tryParse(event.certId) == null) {
        emit(SignupError('شماره شناسنامه خود را وارد کنید'));
        return;
      }

      if (event.sex.isEmpty) {
        emit(SignupError('جنسیت خود را وارد کنید'));
        return;
      }

      emit(SignupLoading());

      SignupStepOneData data = SignupStepOneData(
          phone,
          otp,
          event.fname,
          event.lname,
          event.fatherName,
          event.nc,
          event.certId,
          event.sex,
          event.birthDate,
          event.place,
          event.job);

      DataState<void> result = await _repository.signupStepOne(data);
      emit(result is DataError
          ? SignupError(result.errorMessage!)
          : SignupDoSignupStepTwo());
    });
  }
}
