part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupError extends SignupState {
  final String message;
  SignupError(this.message);
}

class SignupGetOtp extends SignupState {
  final String phone;
  SignupGetOtp(this.phone);
}

class SignupDoSignup extends SignupState {}

class SignupDoSignupStepTwo extends SignupState {}

class SignupDoLogin extends SignupState {}