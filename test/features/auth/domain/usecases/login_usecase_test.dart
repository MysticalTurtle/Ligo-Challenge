import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/auth/domain/entities/user.dart';
import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  group('LoginUsecase', () {
    const testUsername = 'testuser';
    const testPassword = 'testpassword';
    const testUser = User(id: 'user_123', name: 'John Doe');

    test(
      'should return Failure when username is empty',
      () async {
        final result = await usecase(
          username: '',
          password: testPassword,
        );

        expect(result, isA<Failure<User>>());
        expect(
          (result as Failure).message,
          'Please enter both username and password',
        );

        verifyNever(
          () => mockRepository.login(any(), any()),
        );
      },
    );

    test(
      'should return Failure when username is only whitespace',
      () async {
        final result = await usecase(
          username: '   ',
          password: testPassword,
        );

        expect(result, isA<Failure<User>>());
        expect(
          (result as Failure).message,
          'Please enter both username and password',
        );

        verifyNever(
          () => mockRepository.login(any(), any()),
        );
      },
    );

    test(
      'should return Failure when password is empty',
      () async {
        final result = await usecase(
          username: testUsername,
          password: '',
        );

        expect(result, isA<Failure<User>>());
        expect(
          (result as Failure).message,
          'Please enter both username and password',
        );

        verifyNever(
          () => mockRepository.login(any(), any()),
        );
      },
    );

    test(
      'should return Failure when password is only whitespace',
      () async {
        final result = await usecase(
          username: testUsername,
          password: '   ',
        );

        expect(result, isA<Failure<User>>());
        expect(
          (result as Failure).message,
          'Please enter both username and password',
        );

        verifyNever(
          () => mockRepository.login(any(), any()),
        );
      },
    );

    test(
      'should return Failure when both username and password are empty',
      () async {
        final result = await usecase(
          username: '',
          password: '',
        );

        expect(result, isA<Failure<User>>());
        expect(
          (result as Failure).message,
          'Please enter both username and password',
        );

        verifyNever(
          () => mockRepository.login(any(), any()),
        );
      },
    );

    test(
      'should call repository.login and return Success when credentials are valid',
      () async {
        const expectedResult = Success<User>(testUser);
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => expectedResult);

        final result = await usecase(
          username: testUsername,
          password: testPassword,
        );

        expect(result, expectedResult);
        expect(result, isA<Success<User>>());
        expect((result as Success).data, testUser);

        verify(
          () => mockRepository.login(testUsername, testPassword),
        ).called(1);
      },
    );

    test(
      'should call repository.login and return Failure when login fails',
      () async {
        const expectedResult = Failure<User>('Invalid credentials');
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => expectedResult);

        final result = await usecase(
          username: testUsername,
          password: testPassword,
        );

        expect(result, expectedResult);
        expect(result, isA<Failure<User>>());
        expect((result as Failure).message, 'Invalid credentials');

        verify(
          () => mockRepository.login(testUsername, testPassword),
        ).called(1);
      },
    );

    test(
      'should trim whitespace from credentials before calling repository',
      () async {
        const expectedResult = Success<User>(testUser);
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => expectedResult);

        final result = await usecase(
          username: '  $testUsername  ',
          password: '  $testPassword  ',
        );

        expect(result, expectedResult);

        verify(
          () => mockRepository.login(testUsername, testPassword),
        ).called(1);
      },
    );
  });
}
