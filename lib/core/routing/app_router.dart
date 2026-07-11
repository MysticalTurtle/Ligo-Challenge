import 'package:go_router/go_router.dart';
import 'package:ligo_challenge/core/routing/app_routes.dart';
import 'package:ligo_challenge/core/routing/home_shell.dart';
import 'package:ligo_challenge/features/auth/presentation/pages/login_page.dart';
import 'package:ligo_challenge/features/auth/presentation/pages/profile_page.dart';
import 'package:ligo_challenge/features/auth/presentation/splash/splash_page.dart';
import 'package:ligo_challenge/features/movements/domain/entities/movement.dart';
import 'package:ligo_challenge/features/movements/presentation/pages/movement_detail_page.dart';
import 'package:ligo_challenge/features/movements/presentation/pages/movements_page.dart';

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
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
