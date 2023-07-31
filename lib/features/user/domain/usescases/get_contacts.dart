import 'package:dartz/dartz.dart';
import 'package:insttant_plus_mobile/core/network/failure.dart';
import 'package:insttant_plus_mobile/core/usescases/usecase.dart';

import 'package:insttant_plus_mobile/features/user/domain/repositories/user_repository.dart';

import '../entities/contact_entity.dart';

class GetContacts implements UseCase<List<ContactEntity>, NoParams> {
  final UserRepository repository;

  GetContacts({required this.repository});

  @override
  Future<Either<Failure, List<ContactEntity>>> call(NoParams params) async {
    final result = await repository.getContacts();

    return result.fold(
        (failure) => Left(failure),
        (response) => Right(
              response,
            ));
  }
}
