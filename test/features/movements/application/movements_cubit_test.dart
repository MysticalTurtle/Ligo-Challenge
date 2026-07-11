import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/application/movements_cubit.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/domain/usecases/get_movements_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMovementsUsecase extends Mock implements GetMovementsUsecase {}

void main() {
  late MockGetMovementsUsecase mockGetMovementsUsecase;
  late MovementsCubit cubit;

  setUpAll(() {
    registerFallbackValue(MovementType.incoming);
  });

  setUp(() {
    mockGetMovementsUsecase = MockGetMovementsUsecase();
    cubit = MovementsCubit(getMovementsUsecase: mockGetMovementsUsecase);
  });

  tearDown(() async {
    await cubit.close();
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

  group('MovementsCubit', () {
    test('initial state has correct default values', () {
      expect(cubit.state, const MovementsState());
    });

    blocTest<MovementsCubit, MovementsState>(
      'getMovements emits [loading, success] when usecase returns success',
      build: () {
        when(
          () => mockGetMovementsUsecase(
            type: any(named: 'type'),
            searchQuery: any(named: 'searchQuery'),
          ),
        ).thenAnswer((_) async => const Success(testMovements));
        return cubit;
      },
      act: (cubit) => cubit.getMovements(),
      expect: () => [
        const MovementsState(status: MovementsStatus.loading),
        const MovementsState(
          status: MovementsStatus.success,
          movements: testMovements,
        ),
      ],
      verify: (_) {
        verify(() => mockGetMovementsUsecase()).called(1);
      },
    );

    blocTest<MovementsCubit, MovementsState>(
      'getMovements emits [loading, error] when usecase returns failure',
      build: () {
        when(
          () => mockGetMovementsUsecase(
            type: any(named: 'type'),
            searchQuery: any(named: 'searchQuery'),
          ),
        ).thenAnswer((_) async => const Failure('Error fetching data'));
        return cubit;
      },
      act: (cubit) => cubit.getMovements(
        type: MovementType.outgoing,
        searchQuery: 'Pago',
      ),
      expect: () => [
        const MovementsState(
          status: MovementsStatus.loading,
          currentFilter: MovementType.outgoing,
          searchQuery: 'Pago',
        ),
        const MovementsState(
          status: MovementsStatus.error,
          currentFilter: MovementType.outgoing,
          searchQuery: 'Pago',
          error: 'Error fetching data',
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetMovementsUsecase(
            type: MovementType.outgoing,
            searchQuery: 'Pago',
          ),
        ).called(1);
      },
    );

    blocTest<MovementsCubit, MovementsState>(
      'changeFilter triggers getMovements with new filter '
      'and existing search query',
      build: () {
        when(
          () => mockGetMovementsUsecase(
            type: any(named: 'type'),
            searchQuery: any(named: 'searchQuery'),
          ),
        ).thenAnswer((_) async => const Success(testMovements));
        return cubit;
      },
      seed: () => const MovementsState(searchQuery: 'Transferencia'),
      act: (cubit) => cubit.changeFilter(MovementType.incoming),
      expect: () => [
        const MovementsState(
          status: MovementsStatus.loading,
          currentFilter: MovementType.incoming,
          searchQuery: 'Transferencia',
        ),
        const MovementsState(
          status: MovementsStatus.success,
          currentFilter: MovementType.incoming,
          searchQuery: 'Transferencia',
          movements: testMovements,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetMovementsUsecase(
            type: MovementType.incoming,
            searchQuery: 'Transferencia',
          ),
        ).called(1);
      },
    );

    blocTest<MovementsCubit, MovementsState>(
      'submitSearch triggers getMovements with new query and existing filter',
      build: () {
        when(
          () => mockGetMovementsUsecase(
            type: any(named: 'type'),
            searchQuery: any(named: 'searchQuery'),
          ),
        ).thenAnswer((_) async => const Success(testMovements));
        return cubit;
      },
      seed: () => const MovementsState(currentFilter: MovementType.outgoing),
      act: (cubit) => cubit.submitSearch('Pago'),
      expect: () => [
        const MovementsState(
          status: MovementsStatus.loading,
          currentFilter: MovementType.outgoing,
          searchQuery: 'Pago',
        ),
        const MovementsState(
          status: MovementsStatus.success,
          currentFilter: MovementType.outgoing,
          searchQuery: 'Pago',
          movements: testMovements,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetMovementsUsecase(
            type: MovementType.outgoing,
            searchQuery: 'Pago',
          ),
        ).called(1);
      },
    );

    blocTest<MovementsCubit, MovementsState>(
      'clearSearch triggers getMovements and clears the search query',
      build: () {
        when(
          () => mockGetMovementsUsecase(
            type: any(named: 'type'),
            searchQuery: any(named: 'searchQuery'),
          ),
        ).thenAnswer((_) async => const Success(testMovements));
        return cubit;
      },
      seed: () => const MovementsState(
        currentFilter: MovementType.outgoing,
        searchQuery: 'Pago',
      ),
      act: (cubit) => cubit.clearSearch(),
      expect: () => [
        const MovementsState(
          status: MovementsStatus.loading,
          currentFilter: MovementType.outgoing,
        ),
        const MovementsState(
          status: MovementsStatus.success,
          currentFilter: MovementType.outgoing,
          movements: testMovements,
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetMovementsUsecase(
            type: MovementType.outgoing,
          ),
        ).called(1);
      },
    );

    blocTest<MovementsCubit, MovementsState>(
      'reset emits initial state',
      build: () => cubit,
      seed: () => const MovementsState(
        status: MovementsStatus.success,
        movements: testMovements,
        currentFilter: MovementType.outgoing,
        searchQuery: 'Pago',
      ),
      act: (cubit) => cubit.reset(),
      expect: () => [const MovementsState()],
    );
  });
}
