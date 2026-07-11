import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/core/network/connectivity/internet_connectivity_impl.dart';
import 'package:ligo_challenge/core/network/dio_client.dart';
import 'package:ligo_challenge/core/storage/token_storage.dart';
import 'package:ligo_challenge/features/auth/data/data.dart';
import 'package:ligo_challenge/features/auth/domain/domain.dart';
import 'package:ligo_challenge/features/movements/data/data.dart';
import 'package:ligo_challenge/features/movements/domain/repositories/movements_repository.dart';
import 'package:ligo_challenge/features/movements/domain/usecases/get_movements_usecase.dart';

class AppRepositories extends StatelessWidget {
  const AppRepositories({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TokenStorage>(
          create: (context) => TokenStorage(),
        ),
        RepositoryProvider<DioClient>(
          create: (context) => DioClient(
            baseUrl: '',
          ),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            datasource: AuthRemoteDSMock(
              dio: context.read<DioClient>().dio,
            ),
            tokenStorage: context.read<TokenStorage>(),
            internetConnectivity: InternetConnectivityImpl(),
          ),
        ),
        RepositoryProvider<MovementsRepository>(
          create: (context) => MovementsRepositoryImpl(
            datasource: MovementsRemoteDSMock(
              dio: context.read<DioClient>().dio,
            ),
            internetConnectivity: InternetConnectivityImpl(),
          ),
        ),
        RepositoryProvider<LoginUsecase>(
          create: (context) => LoginUsecase(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        RepositoryProvider<LogoutUsecase>(
          create: (context) => LogoutUsecase(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        RepositoryProvider<GetMovementsUsecase>(
          create: (context) => GetMovementsUsecase(
            movementsRepository: context.read<MovementsRepository>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
