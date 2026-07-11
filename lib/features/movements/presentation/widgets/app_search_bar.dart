import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/features/movements/application/movements_cubit.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({super.key});

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
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



  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) {
      _searchController.clear();
      context.read<MovementsCubit>().clearSearch();
    } else {
      context.read<MovementsCubit>().submitSearch(query);
    }
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<MovementsCubit>().clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchController,
        builder: (context, value, child) {
          return TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar movimientos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: value.text.isNotEmpty
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
          );
        },
      ),
    );
  }
}
