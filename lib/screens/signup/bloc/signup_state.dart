part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupError extends SignupState {
  final String message;
  SignupError(this.message);
}

class SignupGetOtp extends SignupState {}

class SignupDoSignup extends SignupState {}

class SignupDoLogin extends SignupState {}