import 'package:get_it/get_it.dart';
import 'package:lawyer_app/core/network/api_client.dart';
import 'package:lawyer_app/core/network/dio_client.dart';
import 'package:lawyer_app/features/lawyer/data/datasources/lawyer_remote_datasource.dart';
import 'package:lawyer_app/features/lawyer/data/repositories/lawyer_repository_impl.dart';
import 'package:lawyer_app/features/lawyer/domain/repositories/lawyer_repository.dart';
import 'package:lawyer_app/features/lawyer/domain/usecases/get_lawyers_usecase.dart';
import 'package:lawyer_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:lawyer_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lawyer_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:lawyer_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:lawyer_app/features/client/data/datasources/client_remote_datasource.dart';
import 'package:lawyer_app/features/client/data/repositories/client_repository_impl.dart';
import 'package:lawyer_app/features/client/domain/repositories/client_repository.dart';
import 'package:lawyer_app/features/client/domain/usecases/client_usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => ApiClient(sl()));

  // Features - Auth
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => OtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // Features - Lawyer
  sl.registerLazySingleton<LawyerRemoteDataSource>(
      () => LawyerRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<LawyerRepository>(
      () => LawyerRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetLawyersUseCase(sl()));

  // Features - Client (Cases)
  sl.registerLazySingleton<ClientRemoteDataSource>(
      () => ClientRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ClientRepository>(
      () => ClientRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateCaseUseCase(sl()));
  sl.registerLazySingleton(() => GetCasesByUserIdUseCase(sl()));
}
