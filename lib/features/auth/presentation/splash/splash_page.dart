import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/core/routing/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthCubit _authCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authCubit = context.read<AuthCubit>();
  }

  @override
  void initState() {
    super.initState();
    unawaited(_checkAuthStatus());
  }

  Future<void> _checkAuthStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final authState = _authCubit.state;

    if (authState.isAuthenticated) {
      context.go(AppRoutes.movements);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 100,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'Ligo Challenge',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
