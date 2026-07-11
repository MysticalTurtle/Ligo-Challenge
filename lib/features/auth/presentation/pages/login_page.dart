import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/features/auth/application/login_cubit.dart';
import 'package:ligo_challenge/features/auth/application/login_state.dart';
import 'package:ligo_challenge/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success && state.user != null) {
            // Navigation will be handled by go_router auth guard
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome, ${state.user!.name}!'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state.status == LoginStatus.error && state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: const Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
