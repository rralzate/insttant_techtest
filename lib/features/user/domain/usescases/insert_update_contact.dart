import 'package:dartz/dartz.dart';
import 'package:insttant_plus_mobile/core/network/failure.dart';
import 'package:insttant_plus_mobile/core/usescases/usecase.dart';
import 'package:insttant_plus_mobile/features/user/domain/entities/contact_entity.dart';
import 'package:insttant_plus_mobile/features/user/domain/repositories/user_repository.dart';

class InsertUpdateContact implements UseCase<int, ContactEntity> {
  final UserRepository repository;

  InsertUpdateContact({required this.repository});

  @override
  Future<Either<Failure, int>> call(ContactEntity params) async {
    final result = await repository.insertUpdateContact(contact: params);

    return result.fold(
        (failure) => Left(failure),
        (response) => Right(
              response,
            ));
  }
}
