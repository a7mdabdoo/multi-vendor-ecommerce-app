import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class LoginSubmittedEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginSubmittedEvent({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}

class RegisterSubmittedEvent extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  const RegisterSubmittedEvent({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

class LoginAsDemoEvent extends AuthEvent {
  const LoginAsDemoEvent();
}

class LogoutRequestedEvent extends AuthEvent {
  const LogoutRequestedEvent();
}
