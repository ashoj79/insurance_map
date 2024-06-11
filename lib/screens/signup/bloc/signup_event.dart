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