import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/logout_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this._loginUsecase,
    required this._logoutUsecase,
  }) : super(const LoginState());

  final LoginUsecase _loginUsecase;
  final LogoutUsecase _logoutUsecase;

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
    emit(state.copyWith(status: LoginStatus.loggedOut));
  }

  void reset() {
    emit(const LoginState());
  }
}
