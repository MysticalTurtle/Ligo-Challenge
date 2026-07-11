import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ligo_challenge/core/utils/result.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/domain/usecases/get_movements_usecase.dart';

part 'movements_state.dart';

class MovementsCubit extends Cubit<MovementsState> {
  MovementsCubit({
    required this._getMovementsUsecase,
  }) : super(const MovementsState());

  final GetMovementsUsecase _getMovementsUsecase;

  void changeFilter(MovementType? type) {
    unawaited(getMovements(type: type, searchQuery: state.searchQuery));
  }

  void submitSearch(String query) {
    unawaited(
      getMovements(
        searchQuery: query,
        type: state.currentFilter,
      ),
    );
  }

  void clearSearch() {
    unawaited(getMovements(type: state.currentFilter));
  }

  Future<void> getMovements({
    MovementType? type,
    String? searchQuery,
  }) async {
    emit(
      state.copyWith(
        status: MovementsStatus.loading,
        currentFilter: () => type,
        searchQuery: () => searchQuery,
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
