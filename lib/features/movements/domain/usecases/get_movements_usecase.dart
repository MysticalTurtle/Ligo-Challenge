import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/domain/repositories/movements_repository.dart';

class GetMovementsUsecase {
  GetMovementsUsecase({required this._movementsRepository});

  final MovementsRepository _movementsRepository;

  Future<Result<List<Movement>>> call({
    MovementType? type,
    String? searchQuery,
  }) async {
    return _movementsRepository.getMovements(
      type: type,
      searchQuery: searchQuery,
    );
  }
}
