import 'package:get_it/get_it.dart';
import 'package:insttant_plus_mobile/features/auth/domain/usescases/get_register_user.dart';
import 'package:insttant_plus_mobile/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:insttant_plus_mobile/features/user/domain/usescases/get_contacts.dart';
import 'package:insttant_plus_mobile/features/user/presentation/bloc/user_bloc.dart';

import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/datasources/auth_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usescases/logout_app_auth_usecase.dart';
import '../../features/auth/domain/usescases/post_login.dart';
import '../../features/auth/domain/usescases/post_register_user.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/user/data/datasources/user_datasource.dart';
import '../../features/user/data/datasources/user_datasource_impl.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/domain/usescases/delete_contact.dart';
import '../../features/user/domain/usescases/get_image_profile.dart';
import '../../features/user/domain/usescases/insert_update_contact.dart';
import '../../features/user/domain/usescases/save_image_profile.dart';
import '../data/database_service.dart';

final getIt = GetIt.instance;

Future<void> injectDependencies() async {
  getIt.registerFactory(
    () => AuthBloc(
      postRegisterUserUseCase: getIt(),
      getRegisterUserUseCase: getIt(),
      logoutAppUseCase: getIt(),
      postLoginUseCase: getIt(),
      authDataSource: getIt(),
    ),
  );

  getIt.registerFactory(
    () => MenuBloc(),
  );

  getIt.registerFactory(
    () => UserBloc(
      saveImageProfile: getIt(),
      getImageProfile: getIt(),
      getRegisterUserUseCase: getIt(),
      insertUpdateContact: getIt(),
      getContacts: getIt(),
      deleteContact: getIt(),
    ),
  );
//USES CASES
  getIt.registerLazySingleton(
    () => PostRegisterUserUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetRegisterUserUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => PostLoginUseCase(repository: getIt()),
  );

  getIt.registerLazySingleton(
    () => SaveImageProfile(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => GetImageProfile(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => LogoutAppUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton(
    () => InsertUpdateContact(repository: getIt()),
  );

  getIt.registerLazySingleton(
    () => GetContacts(repository: getIt()),
  );

  getIt.registerLazySingleton(
    () => DeleteContact(repository: getIt()),
  );

//DOMAIN AND DATA SOURCE
  getIt.registerLazySingleton<AuthDatasource>(
    () => AuthDatasourceImpl(),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImp(
      authDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<UserDatasource>(
    () => UserDatasourceImpl(),
  );

  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userDatasource: getIt(),
    ),
  );

  //! Services
  getIt.registerLazySingleton(() => DataBaseService());
}
