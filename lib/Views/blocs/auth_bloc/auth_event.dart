part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String email , password ;

  RegisterEvent({required this.email, required this.password});
}
