import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';

import '../../../../core/usescases/usecase.dart';
import '../entities/token_entity.dart';
import '../repositories/auth_repository.dart';

class PostLoginUseCase
    implements UseCase<UseCasePostLoginResult, ParamsUseCaseParamsPostLogin> {
  final AuthRepository repository;

  PostLoginUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, UseCasePostLoginResult>> call(
    ParamsUseCaseParamsPostLogin params,
  ) async {
    final result = await repository.login(
      email: params.userName,
      password: params.password,
    );

    return result.fold(
      (failure) => Left(failure),
      (resp) => Right(
        UseCasePostLoginResult(
          result: resp.result,
        ),
      ),
    );
  }
}

class ParamsUseCaseParamsPostLogin {
  final String userName;
  final String password;

  const ParamsUseCaseParamsPostLogin({
    required this.userName,
    required this.password,
  });
}

class UseCasePostLoginResult {
  final TokenEntity result;
  UseCasePostLoginResult({
    required this.result,
  });
}
