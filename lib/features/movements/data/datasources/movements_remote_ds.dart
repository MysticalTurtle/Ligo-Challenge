import 'package:ligo_challenge/features/movements/data/models/movement_model.dart';

abstract class MovementsRemoteDS {
  Future<List<MovementModel>> getMovements({
    String? type,
    String? searchQuery,
  });
}
