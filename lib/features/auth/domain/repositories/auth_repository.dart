import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../entities/new_user_entity.dart';
import '../usescases/get_register_user.dart';
import '../usescases/post_login.dart';
import '../usescases/post_register_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, UseCasePostLoginResult>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UseCasePostRegisterUserResult>> postRegisterUser({
    required NewUserEntity userInfo,
  });

  Future<Either<Failure, UseCaseGetRegisterUserResult>> getRegisterUser();

  Future<Either<Failure, Unit>> logoutApp();
}
