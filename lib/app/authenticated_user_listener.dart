import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/core/routing/app_routes.dart';

/// Listener for authentication state changes
/// Redirects to login when user logs out, or to home when user logs in
class AuthenticatedUserListener extends StatelessWidget {
  const AuthenticatedUserListener({
    required this.router,
    required this.child,
    super.key,
  });

  final GoRouter router;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.isAuthenticated != current.isAuthenticated,
      listener: (context, state) {
        if (state.isAuthenticated) {
          router.go(AppRoutes.movements);
        } else {
          router.go(AppRoutes.login);
        }
      },
      child: child,
    );
  }
}
