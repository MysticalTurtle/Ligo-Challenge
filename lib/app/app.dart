import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/app/app_repositories.dart';
import 'package:ligo_challenge/app/app_view.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/features/auth/domain/domain.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppRepositories(
      child: BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(
          authRepository: context.read<AuthRepository>(),
        ),
        child: const AppView(),
      ),
    );
  }
}
