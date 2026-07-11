import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/app/authenticated_user_listener.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/core/routing/app_router.dart';

class AppView extends StatefulWidget {
  const AppView({
    super.key,
  });

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      authCubit: context.read<AuthCubit>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticatedUserListener(
      router: _appRouter.router,
      child: MaterialApp.router(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: _appRouter.router,
      ),
    );
  }
}
