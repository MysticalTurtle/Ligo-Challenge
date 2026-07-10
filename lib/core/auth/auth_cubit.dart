import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';

/// Auth state
class AuthState extends Equatable {
  const AuthState({this.isAuthenticated = false});

  final bool isAuthenticated;

  AuthState copyWith({bool? isAuthenticated}) {
    return AuthState(isAuthenticated: isAuthenticated ?? this.isAuthenticated);
  }

  @override
  List<Object?> get props => [isAuthenticated];
}

/// Auth state cubit for managing authentication state
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this._authRepository}) : super(const AuthState());

  final AuthRepository _authRepository;

  Future<void> init() async {
    // Check initial auth state
    final isAuthenticated = await _authRepository.isAuthenticated();
    emit(AuthState(isAuthenticated: isAuthenticated));
  }

  /// Refresh authentication state
  Future<void> refresh() async {
    final isAuthenticated = await _authRepository.isAuthenticated();
    emit(AuthState(isAuthenticated: isAuthenticated));
  }

  /// Update auth state (call after login/logout)
  void updateAuthState({required bool isAuthenticated}) {
    emit(AuthState(isAuthenticated: isAuthenticated));
  }
}
