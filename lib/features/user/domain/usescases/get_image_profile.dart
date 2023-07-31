import 'package:dartz/dartz.dart';
import 'package:insttant_plus_mobile/core/network/failure.dart';
import 'package:insttant_plus_mobile/core/usescases/usecase.dart';
import 'package:insttant_plus_mobile/features/user/domain/repositories/user_repository.dart';

class GetImageProfile implements UseCase<String, NoParams> {
  final UserRepository repository;

  GetImageProfile({required this.repository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    final result = await repository.getImageProfile();

    return result.fold(
        (failure) => Left(failure),
        (response) => Right(
              response,
            ));
  }
}
