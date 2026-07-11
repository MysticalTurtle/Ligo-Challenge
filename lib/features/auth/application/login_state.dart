part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, error, loggedOut }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.error,
  });

  final LoginStatus status;
  final User? user;
  final String? error;

  LoginState copyWith({
    LoginStatus? status,
    User? user,
    String? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, error];
}
