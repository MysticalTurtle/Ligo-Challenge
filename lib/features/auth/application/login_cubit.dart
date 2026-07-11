import 'package:bloc/bloc.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/application/login_state.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/logout_usecase.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this._loginUsecase,
    required this._logoutUsecase,
    this._authCubit,
  }) : super(const LoginState());

  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;
  final AuthCubit? _authCubit;

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
          ),
        );
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

  Future<void> logout() async {
    await _logoutUsecase();
    _authCubit?.updateAuthState(isAuthenticated: false);
    emit(const LoginState());
  }

  void reset() {
    emit(const LoginState());
  }
}
