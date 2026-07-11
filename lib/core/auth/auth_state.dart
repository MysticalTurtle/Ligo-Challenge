part of 'auth_cubit.dart';

class AuthState extends Equatable {
  const AuthState({this.isAuthenticated = false, this.user});

  final bool isAuthenticated;
  final User? user;

  AuthState copyWith({bool? isAuthenticated, User? user}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isAuthenticated, user];
}
