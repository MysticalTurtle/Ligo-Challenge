// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/application/login_cubit.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late LoginCubit cubit;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    cubit = LoginCubit(
      loginUsecase: mockLoginUsecase,
      logoutUsecase: mockLogoutUsecase,
    );
  });

  tearDown(() {
    unawaited(cubit.close());
  });

  group('LoginCubit', () {
    const testUsername = 'testuser';
    const testPassword = 'testpassword';
    const testUser = User(id: 'user_123', name: 'John Doe');

    test('initial state should be LoginState with initial status', () {
      expect(cubit.state.status, LoginStatus.initial);
      expect(cubit.state.user, null);
      expect(cubit.state.error, null);
    });

    group('login', () {
      blocTest<LoginCubit, LoginState>(
        'emits [loading, success] when login succeeds',
        build: () {
          when(
            () => mockLoginUsecase(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Success<User>(testUser));
          return cubit;
        },
        act: (cubit) => cubit.login(testUsername, testPassword),
        expect: () => [
          const LoginState(status: LoginStatus.loading),
          const LoginState(
            status: LoginStatus.success,
            user: testUser,
          ),
        ],
        verify: (_) {
          verify(
            () => mockLoginUsecase(
              username: testUsername,
              password: testPassword,
            ),
          ).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [loading, error] when login fails',
        build: () {
          when(
            () => mockLoginUsecase(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => const Failure<User>('Invalid credentials'),
          );
          return cubit;
        },
        act: (cubit) => cubit.login(testUsername, testPassword),
        expect: () => [
          const LoginState(status: LoginStatus.loading),
          const LoginState(
            status: LoginStatus.error,
            error: 'Invalid credentials',
          ),
        ],
        verify: (_) {
          verify(
            () => mockLoginUsecase(
              username: testUsername,
              password: testPassword,
            ),
          ).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits [loading, error] with network error message',
        build: () {
          when(
            () => mockLoginUsecase(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => const Failure<User>('No internet connection'),
          );
          return cubit;
        },
        act: (cubit) => cubit.login(testUsername, testPassword),
        expect: () => [
          const LoginState(status: LoginStatus.loading),
          const LoginState(
            status: LoginStatus.error,
            error: 'No internet connection',
          ),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'calls login usecase with provided credentials',
        build: () {
          when(
            () => mockLoginUsecase(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => const Success<User>(testUser));
          return cubit;
        },
        act: (cubit) => cubit.login('admin', 'password123'),
        verify: (_) {
          verify(
            () => mockLoginUsecase(
              username: 'admin',
              password: 'password123',
            ),
          ).called(1);
        },
      );
    });

    group('logout', () {
      blocTest<LoginCubit, LoginState>(
        'emits [loggedOut] when logout is called',
        build: () {
          when(() => mockLogoutUsecase()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [
          const LoginState(status: LoginStatus.loggedOut),
        ],
        verify: (_) {
          verify(() => mockLogoutUsecase()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'calls logout usecase',
        build: () {
          when(() => mockLogoutUsecase()).thenAnswer((_) async {});
          return cubit;
        },
        act: (cubit) => cubit.logout(),
        verify: (_) {
          verify(() => mockLogoutUsecase()).called(1);
        },
      );

      blocTest<LoginCubit, LoginState>(
        'emits loggedOut from success state',
        build: () {
          when(() => mockLogoutUsecase()).thenAnswer((_) async {});
          return cubit;
        },
        seed: () => const LoginState(
          status: LoginStatus.success,
          user: testUser,
        ),
        act: (cubit) => cubit.logout(),
        expect: () => [
          const LoginState(
            status: LoginStatus.loggedOut,
            user: testUser,
          ),
        ],
      );
    });

    group('reset', () {
      blocTest<LoginCubit, LoginState>(
        'emits initial state when reset is called',
        build: () => cubit,
        seed: () => const LoginState(
          status: LoginStatus.error,
          error: 'Some error',
        ),
        act: (cubit) => cubit.reset(),
        expect: () => [
          const LoginState(status: LoginStatus.initial),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits initial state from success state',
        build: () => cubit,
        seed: () => const LoginState(
          status: LoginStatus.success,
          user: testUser,
        ),
        act: (cubit) => cubit.reset(),
        expect: () => [
          const LoginState(status: LoginStatus.initial),
        ],
      );

      blocTest<LoginCubit, LoginState>(
        'emits initial state from loading state',
        build: () => cubit,
        seed: () => const LoginState(status: LoginStatus.loading),
        act: (cubit) => cubit.reset(),
        expect: () => [
          const LoginState(status: LoginStatus.initial),
        ],
      );
    });
  });
}
