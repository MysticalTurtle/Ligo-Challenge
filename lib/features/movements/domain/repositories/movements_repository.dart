import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';

abstract class MovementsRepository {
  Future<Result<List<Movement>>> getMovements({
    MovementType? type,
    String? searchQuery,
  });
}
