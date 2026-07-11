import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/features/movements/application/movements_cubit.dart';
import 'package:ligo_challenge/features/movements/domain/domain.dart';

class MovementFilters extends StatefulWidget {
  const MovementFilters({super.key});

  @override
  State<MovementFilters> createState() => _MovementFiltersState();
}

class _MovementFiltersState extends State<MovementFilters> {
  void _onFilterChanged(MovementType? type) {
    context.read<MovementsCubit>().changeFilter(type);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovementsCubit, MovementsState>(
      builder: (context, state) {
        return Container(
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
                label: MovementType.incoming.name,
                isSelected: state.currentFilter == MovementType.incoming,
                onTap: () => _onFilterChanged(MovementType.incoming),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: MovementType.outgoing.name,
                isSelected: state.currentFilter == MovementType.outgoing,
                onTap: () => _onFilterChanged(MovementType.outgoing),
              ),
            ],
          ),
        );
      },
    );
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
