import 'dart:io';

import 'package:ligo_challenge/core/network/api_exception.dart';
import 'package:ligo_challenge/core/network/connectivity/internet_connectivity.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/data/datasources/movements_remote_ds.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/domain/repositories/movements_repository.dart';

class MovementsRepositoryImpl implements MovementsRepository {
  MovementsRepositoryImpl({
    required this.datasource,
    required this.internetConnectivity,
  });

  final MovementsRemoteDS datasource;
  final InternetConnectivity internetConnectivity;

  @override
  Future<Result<List<Movement>>> getMovements({
    MovementType? type,
    String? searchQuery,
  }) async {
    if (!await internetConnectivity.hasConnection()) {
      return const Failure(
        'No hay conexión a internet. Por favor, '
        'verifica tu red e inténtalo de nuevo.',
        SocketException('No internet connection'),
      );
    }

    try {
      final movements = await datasource.getMovements(
        type: type?.value,
        searchQuery: searchQuery,
      );
      return Success(movements);
    } on Exception catch (e) {
      if (e is ApiException) {
        return Failure(e.message, e);
      }
      return Failure(
        'Failed to load movements. Please try again.',
        Exception(e),
      );
    }
  }
}
