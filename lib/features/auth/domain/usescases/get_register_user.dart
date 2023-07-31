import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';

import '../../../../core/usescases/usecase.dart';

import '../entities/new_user_entity.dart';
import '../repositories/auth_repository.dart';

class GetRegisterUserUseCase
    implements UseCase<UseCaseGetRegisterUserResult, NoParams> {
  final AuthRepository repository;

  GetRegisterUserUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, UseCaseGetRegisterUserResult>> call(
    NoParams params,
  ) async {
    final result = await repository.getRegisterUser();

    return result.fold(
      (failure) => Left(failure),
      (resp) => Right(
        UseCaseGetRegisterUserResult(
          result: resp.result,
        ),
      ),
    );
  }
}

class UseCaseGetRegisterUserResult {
  final NewUserEntity result;
  UseCaseGetRegisterUserResult({
    required this.result,
  });
}
