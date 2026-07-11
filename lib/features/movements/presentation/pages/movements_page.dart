import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/features/movements/application/movements_cubit.dart';
import 'package:ligo_challenge/features/movements/application/movements_state.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement_type.dart';
import 'package:ligo_challenge/features/movements/presentation/widgets/movement_item.dart';

class MovementsPage extends StatefulWidget {
  const MovementsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => const MovementsPage(),
    );
  }

  @override
  State<MovementsPage> createState() => _MovementsPageState();
}

class _MovementsPageState extends State<MovementsPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    unawaited(context.read<MovementsCubit>().getMovements());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged(MovementType? type) {
    unawaited(context.read<MovementsCubit>().getMovements(type: type));
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) {
      _searchController.clear();
      unawaited(
        context.read<MovementsCubit>().getMovements(clearFilterOnSearch: true),
      );
    } else {
      unawaited(
        context.read<MovementsCubit>().getMovements(
          searchQuery: query,
          clearFilterOnSearch: true,
        ),
      );
    }
  }

  void _clearSearch() {
    _searchController.clear();
    unawaited(
      context.read<MovementsCubit>().getMovements(clearFilterOnSearch: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos', style: TextStyle(fontSize: 20)),
      ),
      body: BlocBuilder<MovementsCubit, MovementsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar movimientos...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: state.searchQuery != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearSearch,
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: _onSearchSubmitted,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Todos',
                      isSelected: state.currentFilter == null,
                      onTap: () => _onFilterChanged(null),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Ingresos',
                      isSelected: state.currentFilter == MovementType.incoming,
                      onTap: () => _onFilterChanged(MovementType.incoming),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Salidas',
                      isSelected: state.currentFilter == MovementType.outgoing,
                      onTap: () => _onFilterChanged(MovementType.outgoing),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: _buildContent(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovementsState state) {
    switch (state.status) {
      case MovementsStatus.initial:
      case MovementsStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case MovementsStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                state.error ?? 'Ocurrió un error',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  unawaited(
                    context.read<MovementsCubit>().getMovements(),
                  );
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case MovementsStatus.success:
        if (state.movements.isEmpty) {
          return const Center(
            child: Text('No se encontraron movimientos.'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            unawaited(
              context.read<MovementsCubit>().getMovements(
                type: state.currentFilter,
              ),
            );
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.movements.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final movement = state.movements[index];
              return MovementItem(movement: movement);
            },
          ),
        );
    }
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chipColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.transparent,
          border: Border.all(
            color: chipColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : chipColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
