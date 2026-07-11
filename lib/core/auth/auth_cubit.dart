import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';

class AuthState extends Equatable {
  const AuthState({this.isAuthenticated = false});

  final bool isAuthenticated;

  AuthState copyWith({bool? isAuthenticated}) {
    return AuthState(isAuthenticated: isAuthenticated ?? this.isAuthenticated);
  }

  @override
  List<Object?> get props => [isAuthenticated];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this._authRepository}) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> init() async {
    final isAuthenticated = await _authRepository.isAuthenticated();
    emit(AuthState(isAuthenticated: isAuthenticated));
  }

  Future<void> refresh() async {
    final isAuthenticated = await _authRepository.isAuthenticated();
    emit(AuthState(isAuthenticated: isAuthenticated));
  }

  void updateAuthState({required bool isAuthenticated}) {
    emit(AuthState(isAuthenticated: isAuthenticated));
  }
}
