import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/features/movements/application/movements_cubit.dart';
import 'package:ligo_challenge/features/movements/domain/usecases/get_movements_usecase.dart';
import 'package:ligo_challenge/features/movements/presentation/widgets/app_search_bar.dart';
import 'package:ligo_challenge/features/movements/presentation/widgets/movement_filters.dart';
import 'package:ligo_challenge/features/movements/presentation/widgets/movement_item.dart';

class MovementsPage extends StatelessWidget {
  const MovementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MovementsCubit(
          getMovementsUsecase: context.read<GetMovementsUsecase>(),
        );
        unawaited(cubit.getMovements());
        return cubit;
      },
      child: const _MovementsView(),
    );
  }
}

class _MovementsView extends StatefulWidget {
  const _MovementsView();

  @override
  State<_MovementsView> createState() => _MovementsViewState();
}

class _MovementsViewState extends State<_MovementsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movimientos',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<MovementsCubit, MovementsState>(
        builder: (context, state) {
          return Column(
            children: [
              const AppSearchBar(),
              const MovementFilters(),
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
                  final cubit = context.read<MovementsCubit>();
                  unawaited(
                    cubit.getMovements(
                      type: cubit.state.currentFilter,
                      searchQuery: cubit.state.searchQuery,
                    ),
                  );
                },
                child: const Text('Reintentar'),
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
            final cubit = context.read<MovementsCubit>();
            unawaited(
              cubit.getMovements(
                type: cubit.state.currentFilter,
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
