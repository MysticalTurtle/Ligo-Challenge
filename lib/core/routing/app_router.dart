import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/core/routing/app_routes.dart';
import 'package:ligo_challenge/features/auth/presentation/pages/login_page.dart';
import 'package:ligo_challenge/features/splash/presentation/pages/splash_page.dart';

/// GoRouter refresh stream from Cubit
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  Future<void> dispose() async{
    await   _subscription.cancel();
    super.dispose();
  }
}

/// App router configuration with auth guards
class AppRouter {
  AppRouter({required this.authCubit});

  final AuthCubit authCubit;

  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isAuthenticated = authCubit.state.isAuthenticated;
      final isSplashRoute = state.matchedLocation == AppRoutes.splash;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      // Don't redirect from splash screen - let it handle navigation
      if (isSplashRoute) {
        return null;
      }

      // If not authenticated and not on login page, redirect to login
      if (!isAuthenticated && !isLoginRoute) {
        return AppRoutes.login;
      }

      // If authenticated and on login page, redirect to movements
      if (isAuthenticated && isLoginRoute) {
        return AppRoutes.movements;
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.movements,
        builder: (context, state) => const MovementsPlaceholder(),
      ),
      GoRoute(
        path: '${AppRoutes.movements}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return MovementDetailPlaceholder(id: id);
        },
      ),
    ],
  );
}

/// Placeholder for movements list page (to be implemented)
class MovementsPlaceholder extends StatelessWidget {
  const MovementsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Logout will be implemented when movements feature is added
              context.go('/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Movements List (To be implemented)'),
      ),
    );
  }
}

/// Placeholder for movement detail page (to be implemented)
class MovementDetailPlaceholder extends StatelessWidget {
  const MovementDetailPlaceholder({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement Detail'),
      ),
      body: Center(
        child: Text('Movement Detail for ID: $id\n(To be implemented)'),
      ),
    );
  }
}
