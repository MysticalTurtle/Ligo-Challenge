import 'package:ligo_challenge/core/network/api_exception.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/data/datasources/movements_remote_ds.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/domain/repositories/movements_repository.dart';

class MovementsRepositoryImpl implements MovementsRepository {
  MovementsRepositoryImpl({
    required this.datasource,
  });

  final MovementsRemoteDS datasource;

  @override
  Future<Result<List<Movement>>> getMovements({
    MovementType? type,
    String? searchQuery,
  }) async {
    try {
      final movements = await datasource.getMovements(
        type: type?.name,
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
