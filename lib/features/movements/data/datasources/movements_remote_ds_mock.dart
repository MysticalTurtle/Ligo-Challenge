import 'package:dio/dio.dart';
import 'package:ligo_challenge/features/movements/data/datasources/movements_remote_ds.dart';
import 'package:ligo_challenge/features/movements/data/models/movement_model.dart';

class MovementsRemoteDSMock implements MovementsRemoteDS {
  MovementsRemoteDSMock({required this.dio});

  final Dio dio;

  @override
  Future<List<MovementModel>> getMovements({
    String? type,
    String? searchQuery,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    final mockResponse = [
      {
        'id': 'mov_001',
        'description': 'Pago QR',
        'amount': 25.5,
        'type': 'out',
        'status': 'completed',
      },
      {
        'id': 'mov_002',
        'description': 'Transferencia recibida',
        'amount': 150.0,
        'type': 'in',
        'status': 'completed',
      },
      {
        'id': 'mov_003',
        'description': 'Pago servicios',
        'amount': 45.75,
        'type': 'out',
        'status': 'completed',
      },
      {
        'id': 'mov_004',
        'description': 'Depósito en efectivo',
        'amount': 200.0,
        'type': 'in',
        'status': 'completed',
      },
      {
        'id': 'mov_005',
        'description': 'Compra en comercio',
        'amount': 89.99,
        'type': 'out',
        'status': 'pending',
      },
      {
        'id': 'mov_006',
        'description': 'Transferencia enviada',
        'amount': 75.0,
        'type': 'out',
        'status': 'completed',
      },
      {
        'id': 'mov_007',
        'description': 'Pago de suscripción',
        'amount': 9.99,
        'type': 'out',
        'status': 'completed',
      },
      {
        'id': 'mov_008',
        'description': 'Depósito por nómina',
        'amount': 1200.0,
        'type': 'in',
        'status': 'completed',
      },
      {
        'id': 'mov_009',
        'description': 'Compra en línea',
        'amount': 59.95,
        'type': 'out',
        'status': 'completed',
      },
      {
        'id': 'mov_010',
        'description': 'Transferencia recibida de amigo',
        'amount': 100.0,
        'type': 'in',
        'status': 'completed',
      },
    ];

    var movements = mockResponse.map(MovementModel.fromJson).toList();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      movements = movements
          .where(
            (movement) => movement.description.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }

    if (type != null) {
      movements = movements
          .where((movement) => movement.type.value == type)
          .toList();
    }

    return movements;
  }
}
