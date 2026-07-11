import 'package:bloc/bloc.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/application/movements_state.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/domain/usecases/get_movements_usecase.dart';

class MovementsCubit extends Cubit<MovementsState> {
  MovementsCubit({
    required this._getMovementsUsecase,
  }) : super(const MovementsState());

  final GetMovementsUsecase _getMovementsUsecase;

  Future<void> getMovements({
    MovementType? type,
    String? searchQuery,
    bool clearFilterOnSearch = false,
  }) async {
    emit(
      state.copyWith(
        status: MovementsStatus.loading,
        currentFilter: type,
        clearFilter: type == null || clearFilterOnSearch,
        searchQuery: searchQuery,
        clearSearch:
            searchQuery == null && state.searchQuery != null && type != null,
      ),
    );

    final result = await _getMovementsUsecase(
      type: type,
      searchQuery: searchQuery ?? state.searchQuery,
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            status: MovementsStatus.success,
            movements: result.data,
          ),
        );
      case Failure():
        emit(
          state.copyWith(
            status: MovementsStatus.error,
            error: result.message,
          ),
        );
    }
  }

  void reset() {
    emit(const MovementsState());
  }
}
