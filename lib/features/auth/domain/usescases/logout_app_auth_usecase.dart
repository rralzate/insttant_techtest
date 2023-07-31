import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';

import '../../../../core/usescases/usecase.dart';
import '../repositories/auth_repository.dart';

class LogoutAppUseCase implements UseCase<Unit, NoParams> {
  final AuthRepository repository;

  LogoutAppUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, Unit>> call(
    NoParams params,
  ) async {
    final result = await repository.logoutApp();

    return result.fold(
      (failure) => Left(failure),
      (resp) => Right(resp),
    );
  }
}
