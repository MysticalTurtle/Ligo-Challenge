import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/features/auth/application/login_cubit.dart';
import 'package:ligo_challenge/features/auth/application/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _documentController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _documentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
        _documentController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.lock_outline,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),

          Text(
            'Bienvenido',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Inicia sesión con tu DNI y contraseña',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          TextFormField(
            controller: _documentController,
            decoration: const InputDecoration(
              labelText: 'DNI',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (value == null || value.length != 8) {
                return 'Ingrese un DNI válido de 8 dígitos';
              }
              return null;
            },
            maxLength: 8,
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _onSubmit(),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Ingrese una contraseña válida de al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final isLoading = state.status == LoginStatus.loading;

              return FilledButton(
                onPressed: isLoading ? null : _onSubmit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Login'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
