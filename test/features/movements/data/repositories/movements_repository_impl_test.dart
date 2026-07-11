import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:ligo_challenge/core/network/api_exception.dart';
import 'package:ligo_challenge/core/network/connectivity/internet_connectivity.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/data/datasources/movements_remote_ds.dart';
import 'package:ligo_challenge/features/movements/data/models/movement_model.dart';
import 'package:ligo_challenge/features/movements/data/repositories/movements_repository_impl.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_status.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:mocktail/mocktail.dart';

class MockMovementsRemoteDS extends Mock implements MovementsRemoteDS {}

class MockInternetConnectivity extends Mock implements InternetConnectivity {}

void main() {
  late MovementsRepositoryImpl repository;
  late MockMovementsRemoteDS mockRemoteDS;
  late MockInternetConnectivity mockConnectivity;

  setUp(() {
    mockRemoteDS = MockMovementsRemoteDS();
    mockConnectivity = MockInternetConnectivity();
    repository = MovementsRepositoryImpl(
      datasource: mockRemoteDS,
      internetConnectivity: mockConnectivity,
    );
  });

  const testModels = [
    MovementModel(
      id: 'mov_001',
      description: 'Pago QR',
      amount: 25.5,
      type: MovementType.outgoing,
      status: MovementStatus.completed,
    ),
    MovementModel(
      id: 'mov_002',
      description: 'Transferencia recibida',
      amount: 150,
      type: MovementType.incoming,
      status: MovementStatus.completed,
    ),
  ];

  group('getMovements', () {
    test(
      'should return Failure with network message when no internet connection',
      () async {
        when(
          () => mockConnectivity.hasConnection(),
        ).thenAnswer((_) async => false);

        final result = await repository.getMovements();

        expect(result, isA<Failure<List<Movement>>>());
        final failure = result as Failure<List<Movement>>;
        expect(failure.message, contains('No hay conexión a internet'));
        expect(failure.exception, isA<SocketException>());
        verify(() => mockConnectivity.hasConnection()).called(1);
        verifyNever(
          () => mockRemoteDS.getMovements(
            type: any(named: 'type'),
            searchQuery: any(named: 'searchQuery'),
          ),
        );
      },
    );

    group('when connected to internet', () {
      setUp(() {
        when(
          () => mockConnectivity.hasConnection(),
        ).thenAnswer((_) async => true);
      });

      test(
        'should return Success with movements when datasource fetches '
        'successfully',
        () async {
          when(
            () => mockRemoteDS.getMovements(
              type: any(named: 'type'),
              searchQuery: any(named: 'searchQuery'),
            ),
          ).thenAnswer((_) async => testModels);

          final result = await repository.getMovements(
            type: MovementType.incoming,
            searchQuery: 'Transferencia',
          );

          expect(result, isA<Success<List<Movement>>>());
          final success = result as Success<List<Movement>>;
          expect(success.data, testModels);
          verify(() => mockConnectivity.hasConnection()).called(1);
          verify(
            () => mockRemoteDS.getMovements(
              type: 'in',
              searchQuery: 'Transferencia',
            ),
          ).called(1);
        },
      );

      test(
        'should return Failure with message from ApiException when '
        'datasource throws ApiException',
        () async {
          final exception = ApiException(message: 'Server error');
          when(
            () => mockRemoteDS.getMovements(
              type: any(named: 'type'),
              searchQuery: any(named: 'searchQuery'),
            ),
          ).thenThrow(exception);

          final result = await repository.getMovements();

          expect(result, isA<Failure<List<Movement>>>());
          final failure = result as Failure<List<Movement>>;
          expect(failure.message, 'Server error');
          expect(failure.exception, exception);
          verify(() => mockConnectivity.hasConnection()).called(1);
          verify(
            () => mockRemoteDS.getMovements(
              type: any(named: 'type'),
              searchQuery: any(named: 'searchQuery'),
            ),
          ).called(1);
        },
      );

      test(
        'should return Failure with generic message when datasource throws '
        'non-Api exception',
        () async {
          final exception = Exception('Unknown database error');
          when(
            () => mockRemoteDS.getMovements(
              type: any(named: 'type'),
              searchQuery: any(named: 'searchQuery'),
            ),
          ).thenThrow(exception);

          final result = await repository.getMovements();

          expect(result, isA<Failure<List<Movement>>>());
          final failure = result as Failure<List<Movement>>;
          expect(
            failure.message,
            'Failed to load movements. Please try again.',
          );
          expect(failure.exception, isA<Exception>());
          verify(() => mockConnectivity.hasConnection()).called(1);
          verify(
            () => mockRemoteDS.getMovements(
              type: any(named: 'type'),
              searchQuery: any(named: 'searchQuery'),
            ),
          ).called(1);
        },
      );
    });
  });
}
