import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';

import '../../../../core/usescases/usecase.dart';
import '../../data/models/token_model.dart';
import '../entities/new_user_entity.dart';
import '../repositories/auth_repository.dart';

class PostRegisterUserUseCase
    implements
        UseCase<UseCasePostRegisterUserResult, ParamsUseCaseRegisterUser> {
  final AuthRepository repository;

  PostRegisterUserUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, UseCasePostRegisterUserResult>> call(
    ParamsUseCaseRegisterUser params,
  ) async {
    final result = await repository.postRegisterUser(
      userInfo: params.infoUserRegisterEntity,
    );

    return result.fold(
      (failure) => Left(failure),
      (resp) => Right(
        UseCasePostRegisterUserResult(
          result: resp.result,
        ),
      ),
    );
  }
}

class ParamsUseCaseRegisterUser {
  final NewUserEntity infoUserRegisterEntity;

  const ParamsUseCaseRegisterUser({
    required this.infoUserRegisterEntity,
  });
}

class UseCasePostRegisterUserResult {
  final TokenModel result;
  UseCasePostRegisterUserResult({
    required this.result,
  });
}
