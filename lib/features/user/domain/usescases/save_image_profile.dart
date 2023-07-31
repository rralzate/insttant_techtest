import 'package:dartz/dartz.dart';
import 'package:insttant_plus_mobile/core/network/failure.dart';
import 'package:insttant_plus_mobile/core/usescases/usecase.dart';
import 'package:insttant_plus_mobile/features/user/domain/repositories/user_repository.dart';

class SaveImageProfile implements UseCase<bool, String> {
  final UserRepository repository;

  SaveImageProfile({required this.repository});

  @override
  Future<Either<Failure, bool>> call(String params) async {
    final result = await repository.saveImageProfile(imagePath: params);

    return result.fold(
        (failure) => Left(failure),
        (response) => Right(
              response,
            ));
  }
}
