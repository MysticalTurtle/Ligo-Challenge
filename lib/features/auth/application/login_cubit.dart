import 'package:bloc/bloc.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/application/login_state.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/logout_usecase.dart';

/// Login cubit
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this._loginUsecase,
    required this._logoutUsecase,
    this._authCubit,
  }) : super(const LoginState());

  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final AuthCubit? _authCubit;

  /// Login with token
  Future<void> login(String user, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginUsecase(
      username: user,
      password: password,
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            status: LoginStatus.success,
            user: result.data,
            error: null,
          ),
        );
        // Notify auth cubit of auth change
        _authCubit?.updateAuthState(isAuthenticated: true);
      case Failure():
        emit(
          state.copyWith(
            status: LoginStatus.error,
            error: result.message,
          ),
        );
    }
  }

  /// Logout
  Future<void> logout() async {
    await _logoutUsecase();
    // Notify auth cubit of auth change
    _authCubit?.updateAuthState(isAuthenticated: false);
    emit(const LoginState());
  }

  /// Reset to initial state
  void reset() {
    emit(const LoginState());
  }
}
