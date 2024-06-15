part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

class SignupSendOtp extends SignupEvent {
  final String phone;
  SignupSendOtp(this.phone);
}

class SignupValidateOtp extends SignupEvent {
  final String phone, otp;
  SignupValidateOtp({required this.phone, required this.otp});
}

class SignupSubmitStepOne extends SignupEvent {
  final String fname, lname, fatherName, nc, certId, sex, birthDate, place, job;
  SignupSubmitStepOne(
      {required this.fname,
      required this.lname,
      required this.fatherName,
      required this.nc,
      required this.certId,
      required this.sex,
      required this.birthDate,
      required this.place,
      required this.job});
}
