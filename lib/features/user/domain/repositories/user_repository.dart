import 'package:dartz/dartz.dart';

import '../../../../core/network/failure.dart';
import '../entities/contact_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, bool>> saveImageProfile({
    required String imagePath,
  });

  Future<Either<Failure, String>> getImageProfile();

  Future<Either<Failure, int>> insertUpdateContact(
      {required ContactEntity contact});

  Future<Either<Failure, int>> deleteContact({required ContactEntity contact});

  Future<Either<Failure, List<ContactEntity>>> getContacts();
}
