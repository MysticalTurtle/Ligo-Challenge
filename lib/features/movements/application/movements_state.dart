import 'package:equatable/equatable.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';

enum MovementsStatus { initial, loading, success, error }

class MovementsState extends Equatable {
  const MovementsState({
    this.status = MovementsStatus.initial,
    this.movements = const [],
    this.error,
    this.currentFilter,
    this.searchQuery,
  });

  final MovementsStatus status;
  final List<Movement> movements;
  final String? error;
  final MovementType? currentFilter;
  final String? searchQuery;

  MovementsState copyWith({
    MovementsStatus? status,
    List<Movement>? movements,
    String? error,
    MovementType? currentFilter,
    String? searchQuery,
    bool clearFilter = false,
    bool clearSearch = false,
  }) {
    return MovementsState(
      status: status ?? this.status,
      movements: movements ?? this.movements,
      error: error ?? this.error,
      currentFilter: clearFilter ? null : (currentFilter ?? this.currentFilter),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
    );
  }

  @override
  List<Object?> get props => [
    status,
    movements,
    error,
    currentFilter,
    searchQuery,
  ];
}
