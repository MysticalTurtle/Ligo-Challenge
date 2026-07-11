import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ligo_challenge/app/authenticated_user_listener.dart';
import 'package:ligo_challenge/core/auth/auth_cubit.dart';
import 'package:ligo_challenge/core/network/dio_client.dart';
import 'package:ligo_challenge/core/routing/app_router.dart';
import 'package:ligo_challenge/core/storage/token_storage.dart';
import 'package:ligo_challenge/features/auth/application/login_cubit.dart';
import 'package:ligo_challenge/features/auth/data/data.dart';
import 'package:ligo_challenge/features/auth/domain/domain.dart';
import 'package:ligo_challenge/features/movements/application/movements_cubit.dart';
import 'package:ligo_challenge/features/movements/data/datasources/movements_remote_ds_mock.dart';
import 'package:ligo_challenge/features/movements/domain/repositories/movements_repository.dart';
import 'package:ligo_challenge/features/movements/domain/usecases/get_movements_usecase.dart';
import 'package:ligo_challenge/features/movements/repository/movements_repository_impl.dart';

class App extends StatefulWidget {
  const App({
    required this.baseUrl,
    super.key,
  });

  final String baseUrl;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final TokenStorage _tokenStorage;
  late final DioClient _dioClient;
  late final AuthRepository _authRepository;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final AuthCubit _authCubit;
  late final MovementsRepository _movementsRepository;
  late final GetMovementsUsecase _getMovementsUsecase;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();

    // Initialize core services
    _tokenStorage = TokenStorage();
    _dioClient = DioClient(
      baseUrl: widget.baseUrl,
      tokenStorage: _tokenStorage,
    );

    // Initialize repositories (using mock datasource for now)
    final authDatasource = AuthRemoteDSMock(dio: _dioClient.dio);
    _authRepository = AuthRepositoryImpl(
      datasource: authDatasource,
      tokenStorage: _tokenStorage,
    );

    final movementsDatasource = MovementsRemoteDSMock(dio: _dioClient.dio);
    _movementsRepository = MovementsRepositoryImpl(
      datasource: movementsDatasource,
    );

    // Initialize use cases
    _loginUsecase = LoginUsecase(authRepository: _authRepository);
    _logoutUsecase = LogoutUsecase(authRepository: _authRepository);
    _getMovementsUsecase = GetMovementsUsecase(
      movementsRepository: _movementsRepository,
    );

    // Initialize auth cubit
    _authCubit = AuthCubit(authRepository: _authRepository);

    // Initialize router
    _appRouter = AppRouter(authCubit: _authCubit);
  }

  @override
  Future<void> dispose() async {
    await _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _movementsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authCubit),
          BlocProvider(
            create: (context) => LoginCubit(
              loginUsecase: _loginUsecase,
              logoutUsecase: _logoutUsecase,
              authCubit: _authCubit,
            ),
          ),
          BlocProvider(
            create: (context) => MovementsCubit(
              getMovementsUsecase: _getMovementsUsecase,
            ),
          ),
        ],
        child: AuthenticatedUserListener(
          router: _appRouter.router,
          child: MaterialApp.router(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              useMaterial3: true,
            ),
            routerConfig: _appRouter.router,
          ),
        ),
      ),
    );
  }
}
