import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/core/routing/app_routes.dart';
import 'package:ligo_challenge/core/routing/home_shell.dart';
import 'package:ligo_challenge/features/auth/presentation/pages/login_page.dart';
import 'package:ligo_challenge/features/auth/presentation/pages/profile_page.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/presentation/pages/movement_detail_page.dart';
import 'package:ligo_challenge/features/movements/presentation/pages/movements_page.dart';
import 'package:ligo_challenge/features/splash/presentation/pages/splash_page.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter({required this.authCubit});

  final AuthCubit authCubit;

  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.movements,
                builder: (context, state) => const MovementsPage(),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) {
                      final movement = state.extra! as Movement;
                      return MovementDetailPage(movement: movement);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
