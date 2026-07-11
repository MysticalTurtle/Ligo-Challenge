import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/core/network/api_exception.dart';
import 'package:ligo_challenge/core/network/connectivity/internet_connectivity.dart';
import 'package:ligo_challenge/core/storage/token_storage.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:ligo_challenge/features/auth/data/models/login_request.dart';
import 'package:ligo_challenge/features/auth/data/models/login_response.dart';
import 'package:ligo_challenge/features/auth/data/models/user_model.dart';
import 'package:ligo_challenge/features/auth/data/repository/auth_repository_impl.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDS extends Mock implements AuthRemoteDS {}

class MockTokenStorage extends Mock implements TokenStorage {}

class MockInternetConnectivity extends Mock implements InternetConnectivity {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDS mockRemoteDS;
  late MockTokenStorage mockTokenStorage;
  late MockInternetConnectivity mockInternetConnectivity;

  setUp(() {
    mockRemoteDS = MockAuthRemoteDS();
    mockTokenStorage = MockTokenStorage();
    mockInternetConnectivity = MockInternetConnectivity();
    repository = AuthRepositoryImpl(
      datasource: mockRemoteDS,
      tokenStorage: mockTokenStorage,
      internetConnectivity: mockInternetConnectivity,
    );

    registerFallbackValue(
      const LoginRequest(user: '', password: ''),
    );
  });

  group('AuthRepositoryImpl', () {
    const testUser = 'testuser';
    const testPassword = 'testpassword';
    const testToken = 'test_token_12345';
    const testUserModel = UserModel(id: 'user_123', name: 'John Doe');
    const testLoginResponse = LoginResponse(
      token: testToken,
      user: testUserModel,
    );

    group('login', () {
      test(
        'should return Failure when there is no internet connection',
        () async {
          when(() => mockInternetConnectivity.hasConnection())
              .thenAnswer((_) async => false);

          final result = await repository.login(testUser, testPassword);

          expect(result, isA<Failure<User>>());
          final failure = result as Failure;
          expect(
            failure.message,
            'No hay conexión a internet. Por favor, '
            'verifica tu red e inténtalo de nuevo.',
          );
          expect(failure.exception, isA<SocketException>());

          verifyNever(() => mockRemoteDS.login(any()));
        },
      );

      test(
        'should call TokenStorage.saveAccessToken and return Success<User> '
        'when login is successful',
        () async {
          when(() => mockInternetConnectivity.hasConnection())
              .thenAnswer((_) async => true);
          when(() => mockRemoteDS.login(any()))
              .thenAnswer((_) async => testLoginResponse);
          when(() => mockTokenStorage.saveAccessToken(any()))
              .thenAnswer((_) async {});

          final result = await repository.login(testUser, testPassword);

          expect(result, isA<Success<User>>());
          expect((result as Success).data, testUserModel);

          verify(() => mockInternetConnectivity.hasConnection()).called(1);
          verify(
            () => mockRemoteDS.login(
              const LoginRequest(user: testUser, password: testPassword),
            ),
          ).called(1);
          verify(() => mockTokenStorage.saveAccessToken(testToken)).called(1);
        },
      );

      test(
        'should return Failure with ApiException message '
        'when ApiException is thrown',
        () async {
          final apiException = ApiException(
            message: 'Invalid credentials',
            statusCode: 401,
          );

          when(() => mockInternetConnectivity.hasConnection())
              .thenAnswer((_) async => true);
          when(() => mockRemoteDS.login(any())).thenThrow(apiException);

          final result = await repository.login(testUser, testPassword);

          expect(result, isA<Failure<User>>());
          final failure = result as Failure;
          expect(failure.message, 'Invalid credentials');
          expect(failure.exception, apiException);

          verifyNever(() => mockTokenStorage.saveAccessToken(any()));
        },
      );

      test(
        'should return generic Failure when a generic Exception is thrown',
        () async {
          final genericException = Exception('Something went wrong');

          when(() => mockInternetConnectivity.hasConnection())
              .thenAnswer((_) async => true);
          when(() => mockRemoteDS.login(any())).thenThrow(genericException);

          final result = await repository.login(testUser, testPassword);

          expect(result, isA<Failure<User>>());
          final failure = result as Failure;
          expect(
            failure.message,
            'Ocurrió un error, Por favor inténtalo de nuevo.',
          );
          expect(failure.exception, isA<Exception>());

          verifyNever(() => mockTokenStorage.saveAccessToken(any()));
        },
      );
    });

    group('logout', () {
      test('should call TokenStorage.clearTokens', () async {
        when(() => mockTokenStorage.clearTokens()).thenAnswer((_) async {});

        await repository.logout();

        verify(() => mockTokenStorage.clearTokens()).called(1);
      });
    });

    group('getAccessToken', () {
      test('should forward call to TokenStorage.getAccessToken', () async {
        const token = 'stored_token';
        when(() => mockTokenStorage.getAccessToken())
            .thenAnswer((_) async => token);

        final result = await repository.getAccessToken();

        expect(result, token);
        verify(() => mockTokenStorage.getAccessToken()).called(1);
      });

      test('should return null when no token is stored', () async {
        when(() => mockTokenStorage.getAccessToken())
            .thenAnswer((_) async => null);

        final result = await repository.getAccessToken();

        expect(result, null);
        verify(() => mockTokenStorage.getAccessToken()).called(1);
      });
    });

    group('isAuthenticated', () {
      test(
        'should forward call to TokenStorage.hasTokens and return true',
        () async {
          when(() => mockTokenStorage.hasTokens())
              .thenAnswer((_) async => true);

          final result = await repository.isAuthenticated();

          expect(result, true);
          verify(() => mockTokenStorage.hasTokens()).called(1);
        },
      );

      test(
        'should forward call to TokenStorage.hasTokens and return false',
        () async {
          when(() => mockTokenStorage.hasTokens())
              .thenAnswer((_) async => false);

          final result = await repository.isAuthenticated();

          expect(result, false);
          verify(() => mockTokenStorage.hasTokens()).called(1);
        },
      );
    });
  });
}
