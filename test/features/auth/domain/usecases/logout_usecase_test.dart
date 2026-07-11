import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/features/auth/domain/repositories/auth_repository.dart';
import 'package:ligo_challenge/features/auth/domain/usecases/logout_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUsecase(authRepository: mockRepository);
  });

  group('LogoutUsecase', () {
    test('should call repository.logout', () async {
      when(() => mockRepository.logout()).thenAnswer((_) async {});

      await usecase();

      verify(() => mockRepository.logout()).called(1);
    });

    test(
      'should complete successfully when repository.logout succeeds',
      () async {
        when(() => mockRepository.logout()).thenAnswer((_) async {});

        await expectLater(usecase(), completes);
        verify(() => mockRepository.logout()).called(1);
      },
    );

    test('should propagate exception when repository.logout throws', () async {
      final exception = Exception('Logout failed');
      when(() => mockRepository.logout()).thenThrow(exception);

      expect(() => usecase(), throwsA(exception));
    });
  });
}
