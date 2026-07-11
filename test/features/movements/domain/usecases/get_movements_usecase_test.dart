import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/domain/repositories/movements_repository.dart';
import 'package:ligo_challenge/features/movements/domain/usecases/get_movements_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMovementsRepository extends Mock implements MovementsRepository {}

void main() {
  late GetMovementsUsecase usecase;
  late MockMovementsRepository mockRepository;

  setUp(() {
    mockRepository = MockMovementsRepository();
    usecase = GetMovementsUsecase(movementsRepository: mockRepository);
  });

  const testMovements = [
    Movement(
      id: 'mov_001',
      description: 'Pago QR',
      amount: 25.5,
      type: MovementType.outgoing,
      status: MovementStatus.completed,
    ),
  ];

  group('GetMovementsUsecase', () {
    test(
      'should forward request parameters to repository and '
      'return success result',
      () async {
        const resultValue = Success(testMovements);
        when(
          () => mockRepository.getMovements(
            type: any(named: 'type'),
            searchQuery: any(named: 'searchQuery'),
          ),
        ).thenAnswer((_) async => resultValue);

        final result = await usecase(
          type: MovementType.outgoing,
          searchQuery: 'Pago',
        );

        expect(result, resultValue);
        verify(
          () => mockRepository.getMovements(
            type: MovementType.outgoing,
            searchQuery: 'Pago',
          ),
        ).called(1);
      },
    );

    test('should return failure result when repository fails', () async {
      const resultValue = Failure<List<Movement>>('Server Error');
      when(
        () => mockRepository.getMovements(
          type: any(named: 'type'),
          searchQuery: any(named: 'searchQuery'),
        ),
      ).thenAnswer((_) async => resultValue);

      final result = await usecase();

      expect(result, resultValue);
      verify(() => mockRepository.getMovements()).called(1);
    });
  });
}
