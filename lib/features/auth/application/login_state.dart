import 'package:equatable/equatable.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';

/// Login status enum
enum LoginStatus {
  /// Initial state
  initial,

  /// Loading state
  loading,

  /// Success state
  success,

  /// Error state
  error,
}

/// Login state
class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.error,
  });

  final LoginStatus status;
  final User? user;
  final String? error;

  /// Create a copy with updated fields
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
