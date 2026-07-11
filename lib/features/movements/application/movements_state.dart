part of 'movements_cubit.dart';

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
    MovementType? Function()? currentFilter,
    String? Function()? searchQuery,
  }) {
    return MovementsState(
      status: status ?? this.status,
      movements: movements ?? this.movements,
      error: error ?? this.error,
      currentFilter: currentFilter != null
          ? currentFilter()
          : this.currentFilter,
      searchQuery: searchQuery != null ? searchQuery() : this.searchQuery,
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
